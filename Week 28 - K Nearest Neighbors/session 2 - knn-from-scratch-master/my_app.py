import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from my_KNeighborsClassifier import KNN

df = pd.read_csv('Social_Network_Ads.csv')

df = df.iloc[:, 1:]

# Label encoding gender col
encoder = LabelEncoder()
df['Gender'] = encoder.fit_transform(df['Gender'])

# scaling all the input features
scaler = StandardScaler()

X = df.iloc[:, 0:3].values
X = scaler.fit_transform(X)

y = df.iloc[:, -1].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=10)

knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X_train, y_train)

y_pred = knn.predict(X_test)

print("X_train shape: ", X_train.shape)
print("X_test shape: ", X_test.shape)

print("Accuracy score using sklearn KNN: ", accuracy_score(y_test, y_pred))

apna_knn = KNN(k=5)

apna_knn.fit(X_train, y_train)

y_pred1 = apna_knn.predict(X_test)

print("Accuracy Score using my class KNN", accuracy_score(y_test, y_pred1))











