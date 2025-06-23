import json,re, csv, sys

# read call.dot
call_nodes = {}
with open('call.dot') as f:
    for line in f:
        m = re.search(r'"([^.]+)\.([^"]+)" \[ label = "([^"]+)"(?:, color = "([^"]+)")?', line)
        if m:
            contract, func, label, color = m.groups()
            key = (contract, func)
            call_nodes[key] = {'contract': contract, 'function': func, 'color': color}

# read slither.json
with open('slither.json') as f:
    data = json.load(f)

func_info = {}
for det in data.get('results', {}).get('detectors', []):
    desc_text = det.get('description','') + det.get('markdown','')
    for el in det.get('elements', []):
        if el.get('type') == 'function':
            tsf = el.get('type_specific_fields') or {}
            sig = tsf.get('signature')
            parent_info = tsf.get('parent') or {}
            parent = parent_info.get('name')
            if not sig or not parent: continue
            key = (parent, sig.split('(')[0])
            info = func_info.setdefault(key, {'contract': parent, 'function': sig.split('(')[0],
                                              'writesPool': False, 'balanceChange': False})
            text = json.dumps(el) + desc_text
            if 'PoolManager' in text:
                info['writesPool'] = True
            if 'transfer' in text or 'Currency' in text or 'WETH' in text:
                info['balanceChange'] = True

# merge color info to determine isExternal
rows = []
for key, info in func_info.items():
    color = call_nodes.get(key, {}).get('color')
    is_external = color == 'blue'
    info['isExternal'] = is_external
    rows.append(info)

with open('static_map.csv','w',newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['contract','function','isExternal','writesPool','balanceChange'])
    writer.writeheader()
    for r in rows:
        writer.writerow(r)

# rank top 20 by risk: High if all True, Medium if 2 True, else Low
for r in rows:
    score = sum([r['isExternal'], r['writesPool'], r['balanceChange']])
    if score >=3:
        r['risk'] = 'High'
    elif score==2:
        r['risk'] = 'Med'
    else:
        r['risk'] = 'Low'

rows.sort(key=lambda x: {'High':3,'Med':2,'Low':1}[x['risk']], reverse=True)

with open('high_risk_modules.md','w') as f:
    f.write('# Top 20 High Risk Functions\n')
    for r in rows[:20]:
        f.write(f"- {r['contract']}.{r['function']} ({r['risk']})\n")
