import asyncio

async def count():
    print("One")
    await asyncio.sleep(1)
    print("Two")

async def test():
    await asyncio.gather(count(), count(), count())

asyncio.run(test())