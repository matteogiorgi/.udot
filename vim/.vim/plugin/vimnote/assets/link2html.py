# use the flag --filter=FILE like this:
# --filter=$pandoc/assets/link2html.py


import panflute as pf

def action(elem, doc):
    if isinstance(elem, pf.Link) and elem.url.endswith('.md'):
        elem.url = elem.url[:-3] + '.html'
        return elem

if __name__ == '__main__':
    pf.run_filter(action)
