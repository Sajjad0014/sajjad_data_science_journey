# steps to perform
# open google.com
# search campusx
# learnwith.campusx.in
# dsmp course

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
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

driver.get("https://google.com")
time.sleep(2)

# Fetch the search input box using xpath
user_input = driver.find_element(by=By.XPATH, value='//*[@id="APjFqb"]')
user_input.send_keys('Campusx')
time.sleep(1)

user_input.send_keys(Keys.ENTER)
time.sleep(1)

link = driver.find_element(by=By.XPATH, value='//*[@id="rso"]/div[1]/div/div/div/div/div/div/div/div[1]/div/span/a')
link.click()
time.sleep(1)

link_2 = driver.find_element(by=By.XPATH,
                             value='//*[@id="1698390585510d"]/div/div[1]/div/div/div/div[1]/div/div/div[2]/a[2]')
link_2.click()
