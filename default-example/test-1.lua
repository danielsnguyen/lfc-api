local comm = require("main")

comm:init("x")
print(comm:waitrecieve("x"))