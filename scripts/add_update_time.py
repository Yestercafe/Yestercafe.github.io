import os

os.chdir('../_posts')
markdowns_names = [fn for fn in filter(lambda fn : fn.endswith('.md'), os.listdir())]
for filename in markdowns_names:
    contents = []
    exist_update_time = False
    with open(filename) as r:
        contents = r.readlines()
        sept_cnt = 0
        for line in contents:
            if sept_cnt >= 2:
                break
            if line.strip() == '---':
                sept_cnt += 1
            if line.startswith('update_time: '):
                exist_update_time = True

    if exist_update_time:
        print('{} exists update_time attr'.format(filename))
    else:
        with open(filename, 'w') as w:
            s = filename.split('-')
            date = '-'.join(s[:3])
            contents.insert(1, 'update_time: {}\n'.format(date))
            w.writelines(contents)
            print('{} added'.format(filename))
