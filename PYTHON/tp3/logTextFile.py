class logTextFile:

    def __init__(self, filename):
        self.filename = filename

    def readFile(self):
        try:
            file = open(self.filename, "r")
            content = file.read()
            file.close()
            return content
        except FileNotFoundError:
            return None

    def writeToFile(self, content):
        try:
            file = open(self.filename, "a")
            file.write(content)
            file.close()
        except Exception:
            return None

    def clearFile(self):
        try:
            file = open(self.filename, "w")
            file.write("")
            file.close()
        except Exception:
            return None
        pass
