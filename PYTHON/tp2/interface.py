"""
GUI for server-client
Early stages. Not fully implemented.
Will open the initial login stage and validate against 2 available names.
Errors after choosing to open Server and Client

"""

import threading
from tkinter import messagebox
import server
import client
import pyodbc
from tkinter import *


def main():
    # Associated Classes
    class Std_redirector(object):
        def __init__(self, widget):
            self.widget = widget

        def write(self, string):
            self.widget.insert(END, string)
            self.widget.see(END)

    # App Login Accounts *** USERNAME FOR TESTING PURPOSES
    username = "jane"
    username2 = "tarzan"

    def login():
        if usernameAsk.get() == username:
            messagebox.showinfo("SUCCESS!", "Hello " + username + " !", icon="info")
            flatWindow.deiconify()
            loginWindow.withdraw()
        elif usernameAsk.get() == username2:
            messagebox.showinfo("SUCCESS!", "Hello " + username2 + " !", icon="info")
            flatWindow.deiconify()
            loginWindow.withdraw()
        else:
            messagebox.showinfo("ERROR!", "Username is incorrect!", icon="error")

    # Login Window
    loginWindow = Tk()
    loginWindow.resizable(width=FALSE, height=FALSE)
    loginWindow.title("### Chat ###")
    loginWindow.geometry("330x115")

    usernameDocket = Label(loginWindow, text="Username:")
    usernameAsk = Entry(loginWindow)
    usernameDocket.pack()
    usernameAsk.pack()
    loginDocket = Button(text="Login", bg="PaleGreen2", fg="green", command=login)
    loginDocket.pack(side=BOTTOM)

    def openServer():

        srv = server.server("0.0.0.0", 8000)
        srv.start()

        serverThread = threading.Thread(target=srv.start, args=())
        serverThread.start()

        serverWindow = Toplevel()
        serverWindow.title('### SERVER ###')
        serverWindow.minsize(width=500, height=300)
        serverContainer = Frame(serverWindow)
        serverContainer.pack()
        text = Text(serverWindow)
        text.pack()
        sys.stdout = Std_redirector(text)

        serverWindow.mainloop()

    # Client Window
    def openClient():
        clientWindow = Toplevel()
        clientWindow.title('### CLIENT ###')
        clientWindow.minsize(width=500, height=400)
        clientContainer = Frame(clientWindow)
        clientContainer.pack()
        text2 = Text(clientWindow)
        text2.pack()
        sys.stdout = Std_redirector(text2)

        conn = client.client("127.0.0.1", 8000)
        conn.start()

        clientThread = threading.Thread(target=conn.start, args=())
        clientThread.start()

        sv = StringVar()
        startEntry = Entry(clientWindow, textvariable=sv, width="30")
        startEntry.insert(0, '')
        startEntry.pack()
        startEntry.bind()

        def printInBox():
            str = startEntry.get()
            print(str)
            conn.send_message(str)
            startEntry.delete(0, END)

        plotButton = Button(clientWindow, bg="PaleGreen2", fg="green", text="SEND", command=printInBox)
        plotButton.pack()
        clientWindow.mainloop()

    # Root Window
    flatWindow = Toplevel()
    flatWindow.title('### CHAT ###')
    flatWindow.minsize(width=500, height=360)
    label = StringVar()
    docket = Label(flatWindow, textvariable=label, bd=1, relief=SUNKEN)
    docket.pack(side=BOTTOM, fill=X)
    topContainer = Frame(flatWindow)
    topContainer.pack()  # default header
    bottomContainer = Frame(flatWindow)
    bottomContainer.pack(side=BOTTOM)
    logoDocket = Label(flatWindow)
    logoDocket.pack(side=TOP)

    # Root Buttons
    button6 = Button(bottomContainer, text="RUN SERVER", bg="SkyBlue1", fg="blue", command=openServer)
    button7 = Button(bottomContainer, text="RUN CLIENT", bg="SkyBlue1", fg="blue", command=openClient)
    button6.pack(side=TOP)
    button7.pack(side=TOP)

    # Root Auto Config
    flatWindow.withdraw()
    flatWindow.mainloop()


if __name__ == "__main__":
    main()
