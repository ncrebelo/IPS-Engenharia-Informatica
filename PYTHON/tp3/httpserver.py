"""
 Simple multi-threaded HTTP Server

"""
import json
import socket
import threading
import logTextFile
import utils
from datetime import datetime


class HTTPServer:
    """The HTTP/1.1 server."""

    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.sock = None
        self.threads = []

    def start(self):
        """Starts the server."""
        self.sock = socket.socket()
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))
        self.sock.listen(1)
        print('Listening on port %s ...' % self.port)

        try:
            while True:
                # Accept client connections
                conn, address = self.sock.accept()

                # Starts the client connection thread
                thread = HTTPConnection(conn, address)
                thread.start()

                # Add to list
                self.threads.append(thread)

        except ConnectionAbortedError:
            pass
        except OSError:
            pass

    def stop(self):
        """Stops the server."""
        self.sock.close()
        for thread in self.threads:
            thread.stop()


def headerParserUrl(request):
    headers = request.split(' ')
    return headers[1]


def headerParserMethod(request):
    headers = request.split(' ')
    return headers[0]


def parseJson(request):
    jsonForm = json.dumps(request)
    return jsonForm


class HTTPConnection(threading.Thread):
    """The HTTP/1.1 client connection."""

    def __init__(self, conn, address):
        super().__init__()
        self.conn = conn
        self.address = address
        self.active = True
        self.mediaFileTypes = {"html": "text/html",
                               "jpg": "jpg",
                               "png": "png",
                               "mp4": "mp4",
                               "mp3": "mp3",
                               "json": "json"
                               }
        self.statusCodes = {"200": "200 Ok",
                            "400": "400 BAD REQUEST\n\nBad Request",
                            "403": "403 FORBIDDEN\n\nForbidden",
                            "404": "404 NOT FOUND\n\nFile not found"
                            }
        self.logStatusCodes = {"200": "200 Ok",
                               "400": "400 Bad Request",
                               "403": "403 Forbidden",
                               "404": "404 Not found"
                               }

    def mediaTypeParser(self, request):
        if request == "/":
            mType = self.mediaFileTypes["html"]
        else:
            headers = request.split('.')
            tempHeader = headers[1]
            if tempHeader == "html":
                mType = self.mediaFileTypes["html"]
            elif tempHeader == "jpg":
                mType = self.mediaFileTypes["jpg"]
            elif tempHeader == "png":
                mType = self.mediaFileTypes["png"]
            elif tempHeader == "mp3":
                mType = self.mediaFileTypes["mp3"]
            elif tempHeader == "mp4":
                mType = self.mediaFileTypes["mp4"]
            else:
                mType = "Error: Media Type"
        return mType

    def writeToLog(self, filename, method):
        log = logTextFile.logTextFile("log.txt")
        timeStamp = datetime.now()
        if filename == "/":
            filename = "index.html"

        if filename.startswith("/private"):
            log.writeToFile(
                "<" + utils.MyDateTime.date_and_TimeFormat(timeStamp) + ">" + " " +
                method + " " +
                filename + " - " +
                self.logStatusCodes["403"] +
                "\n")
        elif filename:
            log.writeToFile(
                "<" + utils.MyDateTime.date_and_TimeFormat(timeStamp) + ">" + " " +
                method + " " +
                filename + " - " +
                self.logStatusCodes["200"] +
                "\n")

    def handleRequest(self, request):
        method = headerParserMethod(request)
        fileName = headerParserUrl(request)
        self.writeToLog(fileName, method)

        if fileName.endswith("py") or fileName.startswith("/private"):
            res = "HTTP/1.1 %s" % (self.statusCodes["403"])
            return res
        elif fileName.startswith("/public/no"):
            res = "HTTP/1.1 %s" % (self.statusCodes["404"])
            return res
        elif method == "GET" and fileName == "/form" or fileName == "/json":
            res = "HTTP/1.1 %s" % (self.statusCodes["404"])
            return res

        elif method == "GET":
            try:
                if fileName == "/":
                    with open("htdocs" + "/index.html") as fin:
                        body = fin.read()
                        cType = self.mediaTypeParser(fileName)
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(body), cType, body)
                        fin.close()
                        return res
                elif fileName.startswith("/public/ipsum"):
                    with open("htdocs" + "/public/ipsum.html") as fin:
                        body = fin.read()
                        cType = self.mediaTypeParser(fileName)
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(body), cType, body)
                        fin.close()
                        return res
                elif fileName.startswith("/assets/image"):
                    with open("htdocs" + "/public/images.html", "rb") as fin:
                        body = fin.read()
                        cType = self.mediaTypeParser(fileName)
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(body), cType, body)
                        fin.close()
                        return res
                elif fileName.startswith("/assets/audio"):
                    with open("htdocs" + "/public/audio.html", "rb") as fin:
                        body = fin.read()
                        cType = self.mediaTypeParser(fileName)
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(body), cType, body)
                        fin.close()
                        return res
                elif fileName.startswith("/assets/video"):
                    with open("htdocs" + "/public/video.html") as fin:
                        body = fin.read()
                        cType = self.mediaTypeParser(fileName)
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(body), cType, body)
                        fin.close()
                        return res
            except FileNotFoundError:
                res = "HTTP/1.1 %s" % (self.statusCodes["404"])
                return res

        elif method == "POST":
            try:
                if fileName == "/form":
                    with open("htdocs" + "/public/form.html") as fin:
                        body = fin.read()
                        jsonBody = parseJson(body)
                        cType = self.mediaFileTypes["json"]
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(jsonBody), cType,
                                                                                           jsonBody)
                        fin.close()
                        return res
                elif fileName == "/json":
                    with open("htdocs" + "/public/json.html") as fin:
                        body = fin.read()
                        cType = self.mediaFileTypes["json"]
                        res = 'HTTP/1.1 %s\nContent-Length: %s\nContent-Type: %s\n\n%s' % (self.statusCodes['200'],
                                                                                           len(body), cType,
                                                                                           body)
                        fin.close()
                        return res
            except FileNotFoundError:
                res = "HTTP/1.1 %s" % (self.statusCodes["404"])
                return res

    def stop(self):
        """Stops the client thread."""
        self.active = False
        self.conn.close()

    def run(self):
        """Handles the client connection."""

        while self.active:
            # Receive message
            msg = self.conn.recv(1024).decode()
            print('Received:', msg)

            # Handle response
            res = self.handleRequest(msg)
            # print(res)

            # Send response
            self.conn.sendall(res.encode())

        # Close client connection
        print('Client disconnected...')
        self.conn.close()


if __name__ == '__main__':
    # Starts the http server
    server = HTTPServer('0.0.0.0', 8000)
    server.start()
