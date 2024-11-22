from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

driver_path = Service("C:/Sajjad/Learnings/chrome drivers/chromedriver-win64/chromedriver.exe")

# Set the different option for the browser
chrome_options = Options()
chrome_options.add_experimental_option('detach', True)
chrome_options.add_experimental_option('excludeSwitches', ['enable-logging'])

# Ignore the certificate and SSL errors
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_argument('--ignore-ssl-errors')

# Maximize the browser window
chrome_options.add_argument('start-maximized')

# Define the driver and open the browser
driver = webdriver.Chrome(service=driver_path, options=chrome_options)

driver.get('https://www.ajio.com/men-backpacks/c/830201001')

old_height = driver.execute_script('return document.body.scrollHeight')

counter = 1
while True:
    driver.execute_script('window.scrollTo(0, document.body.scrollHeight)')
    time.sleep(2)

    new_height = driver.execute_script('return document.body.scrollHeight')

    print(counter)
    counter += 1
    print(old_height)
    print(new_height)
    if new_height == old_height:
        break

    old_height = new_height

html_code = driver.page_source

with open('ajio.html', 'w', encoding='utf-8') as f:
    f.write(html_code)