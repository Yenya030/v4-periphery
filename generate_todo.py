import pandas as pd

# Load static map
static_df = pd.read_csv('static_map.csv')

# Load flagged list
flagged_pairs = set()
with open('flagged.txt') as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        if ',' in line:
            contract, func = line.split(',', 1)
            flagged_pairs.add((contract.strip(), func.strip()))

# Drop flagged rows
mask_flagged = static_df.apply(lambda r: (r['contract'], r['function']) in flagged_pairs, axis=1)
filtered = static_df[~mask_flagged].copy()

# Keep only interesting rows
conditions = (filtered['balanceChange'] == True) | (filtered['writesPool'] == True) | (filtered['isExternal'] == True)
todo_df = filtered[conditions].copy()

# Write todo_static.csv
todo_df.to_csv('todo_static.csv', index=False)

# Add flag count column for heatmap
flags = ['balanceChange', 'writesPool', 'isExternal']
todo_df['flag_count'] = todo_df[flags].sum(axis=1)

# Use pandas styling to create HTML heatmap
styled = todo_df.style.background_gradient(subset=['flag_count'], cmap='Reds')
styled = styled.hide(axis='index')
html_content = styled.to_html()

with open('heatmap.html', 'w') as f:
    f.write(html_content)
