import streamlit as st
import pandas as pd
import time

st.title('Startup Dashboard')
st.header('I am learning Streamlit. It is fire')
st.subheader('And I am loving it')

st.write('Hi')

st.markdown("""
### My favourite movies
- Race 3 
- Humshakals
- `Housefull`
""")

st.code("""
def foo(input):
    return input ** 2

output = foo(2)
""")

st.latex('x^2 + y^2 + 2 = 0')

df = pd.DataFrame({
    'name': ['Superman', 'Batman', 'Flash'],
    'marks': [50, 60, 70],
    'package': [10, 24, 9]
})

st.dataframe(df)

st.metric('Revenue: ', "Rs 3L", '-3%')

st.json({
    'name': ['Superman', 'Batman', 'Flash'],
    'marks': [50, 60, 70],
    'package': [10, 24, 9]
})

st.image('flick.jpg')
st.video('dbz.mp4')

st.sidebar.title('Sidebar ka Title')

col1, col2 = st.columns(2)

with col1:
    st.image('flick.jpg')

with col2:
    st.image('hansi_flick.jpg')

st.error('Login Failed')
st.success('Login successful')
st.warning('There is something wrong')
st.info('This is a piece of information')

progress_bar = st.progress(0)

for i in range(1, 101):
    # time.sleep(0.1)
    progress_bar.progress(i)

email = st.text_input('Input email: ')
number = st.number_input('Enter your age: ')
date = st.date_input('Enter registration date')
# print(email)

import streamlit as st

email = st.text_input('Enter email')
password = st.text_input("Enter password")
gender = st.selectbox('Select gender', ['male', 'female'])

btn = st.button('Login Karo')

if btn:
    if email == 'batsy@gmail.com' and password == 'bruce':
        st.balloons()
        st.write(gender)
    else:
        st.error('Login Failed')

file = st.file_uploader('Upload a csv file')

if file is not None:
    df = pd.read_csv(file)
    st.dataframe(df.describe())
