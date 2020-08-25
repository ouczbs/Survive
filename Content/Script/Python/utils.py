def UPrint(*params):
    params = map(str,params)
    result = " ".join(params)
    print(result)
    with open("python.log", "ab+") as f:
        result = result + "\n"
        f.write(result.encode())
def RePlaceRegions(pbcContent, symbol , content):
    fIdx = pbcContent.find(symbol )
    lIdx = pbcContent.rfind(symbol)
    outAutoGen = pbcContent
    if fIdx != lIdx :
        outAutoGen = pbcContent[:fIdx] + symbol + b"\n" + content + b"\n\t" + symbol + pbcContent[lIdx + len(symbol):]
    return outAutoGen