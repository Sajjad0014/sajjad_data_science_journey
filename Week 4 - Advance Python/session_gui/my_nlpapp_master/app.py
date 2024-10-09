from tkinter import *
from tkinter import messagebox
from mydb import Database
from myapi import API


class NLPApp:

    def __init__(self):
        # create db object
        self.db_obj = Database()
        self.api_obj = API()

        # Login ka gui load karna
        self.password = None
        self.email_input = None
        self.name_input = None
        self.root = Tk()
        self.root.title('NLPApp')
        self.root.iconbitmap('resources/favicon.ico')
        self.root.geometry('350x600')
        self.root.config(bg='#1b4f72')

        self.login_gui()

        self.root.mainloop()

    def login_gui(self):
        self.clear()
        heading = Label(self.root, text='NLPApp', bg='#1b4f72', fg='white')
        heading.pack(pady=(30, 30))
        heading.configure(font=('verdana', 24, 'bold'))

        self.enter_email_password()

        login_btn = Button(self.root, text='Login', width=25, height=2,
                           command=self.perform_login)
        login_btn.pack(pady=(10, 10))

        label3 = Label(self.root, text='Not a member?')
        label3.pack(pady=(70, 10))

        redirect_btn = Button(self.root, text='Register Now', command=self.register_gui)
        redirect_btn.pack(pady=(10, 10))

    def register_gui(self):
        self.clear()

        heading = Label(self.root, text='NLPApp', bg='#1b4f72', fg='white')
        heading.pack(pady=(30, 30))
        heading.configure(font=('verdana', 24, 'bold'))

        label0 = Label(self.root, text='Enter Name')
        label0.pack(pady=(10, 10))

        self.name_input = Entry(self.root, width=50)
        self.name_input.pack(pady=(5, 10), ipady=4)

        self.enter_email_password()

        redirect_btn = Button(self.root, text='Register Now', width=25, height=2,
                              command=self.perform_registration)
        redirect_btn.pack(pady=(10, 10))

        label3 = Label(self.root, text='Already a member?')
        label3.pack(pady=(70, 10))

        login_btn = Button(self.root, text='Login Now', command=self.login_gui)
        login_btn.pack(pady=(10, 10))

    def enter_email_password(self):
        label1 = Label(self.root, text='Enter Email')
        label1.pack(pady=(10, 10))

        self.email_input = Entry(self.root, width=50)
        self.email_input.pack(pady=(5, 10), ipady=4)

        label2 = Label(self.root, text='Enter Password')
        label2.pack(pady=(10, 10))

        self.password = Entry(self.root, width=50, show='*')
        self.password.pack(pady=(5, 10), ipady=4)

    def clear(self):
        # Clear the existing gui
        for widget in self.root.pack_slaves():
            widget.destroy()

    def perform_registration(self):
        # fetch data from gui
        name = self.name_input.get()
        email = self.email_input.get()
        password = self.password.get()

        response = self.db_obj.add_data(name, email, password)
        if response:
            messagebox.showinfo('Success', 'Registration successful, you can login now')
        else:
            messagebox.showerror('Error', 'Email already exists')

    def perform_login(self):
        # fetch data from gui
        email = self.email_input.get()
        password = self.password.get()

        response = self.db_obj.search(email, password)

        if response:
            messagebox.showinfo('Success', 'Login successful')
            self.home_gui()
        else:
            messagebox.showerror('Error', 'Incorrect email/password')

    def home_gui(self):

        self.clear()

        heading = Label(self.root, text='NLPApp', bg='#1b4f72', fg='white')
        heading.pack(pady=(30, 30))
        heading.configure(font=('verdana', 24, 'bold'))

        sentiment_btn = Button(self.root, text='Sentiment Analysis', width=30, height=4,
                               command=self.sentiment_gui)
        sentiment_btn.pack(pady=(10, 10))

        ner_btn = Button(self.root, text='Named Entity Recognition', width=30, height=4,
                         command=self.perform_registration)
        ner_btn.pack(pady=(10, 10))

        headline_btn = Button(self.root, text='Headline Generation', width=30, height=4,
                              command=self.perform_registration)
        headline_btn.pack(pady=(10, 10))

        logout_btn = Button(self.root, text='Logout', command=self.login_gui)
        logout_btn.pack(pady=(10, 10))

    def sentiment_gui(self):

        self.clear()

        heading = Label(self.root, text='NLPApp', bg='#1b4f72', fg='white')
        heading.pack(pady=(30, 30))
        heading.configure(font=('verdana', 24, 'bold'))

        heading2 = Label(self.root, text='Sentiment Analysis', bg='#1b4f72', fg='white')
        heading2.pack(pady=(10, 20))
        heading2.configure(font=('verdana', 18))

        label1 = Label(self.root, text='Enter the text')
        label1.pack(pady=(10, 10))

        self.sentiment_input = Entry(self.root, width=50)
        self.sentiment_input.pack(pady=(5, 10), ipady=4)

        sentiment_btn = Button(self.root, text='Analyze sentiment', command=self.do_sentiment_analysis)
        sentiment_btn.pack(pady=(10, 10))

        self.sentiment_result = Label(self.root, text='-----------output----------', bg='#1b4f72', fg='white')
        self.sentiment_result.pack(pady=(10, 10))
        self.sentiment_result.configure(font=('verdana', 18))

        goback_btn = Button(self.root, text='Go Back', command=self.home_gui)
        goback_btn.pack(pady=(10, 10))

    def do_sentiment_analysis(self):

        text = self.sentiment_input.get()
        result = self.api_obj.sentimen_analysis(text)

        print(result)
        txt = ''
        for i in result['sentiment']:
            txt = txt + i + ' -> ' + str(result['sentiment'][i]) + '\n'

        self.sentiment_result['text'] = txt


nlp = NLPApp()
