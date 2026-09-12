import os
import re
import glob

# Path to repositories
repo_dir = r'packages/presensi_data/lib/src/repositories/'
files = glob.glob(repo_dir + '**/*.dart', recursive=True)

count = 0
for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Replace log.e
    content = re.sub(
        r'(catch\s*\([^,]+,\s*([a-zA-Z0-9_]+)\)\s*\{[\s\n]*)(log\.e\()',
        r'\1if (e is! CacheException) \3',
        content
    )
    
    # Replace logger.e
    content = re.sub(
        r'(catch\s*\([^,]+,\s*([a-zA-Z0-9_]+)\)\s*\{[\s\n]*)(logger\.e\()',
        r'\1if (e is! CacheException) \3',
        content
    )

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
        count += 1

print(f'Processed {count} files.')
