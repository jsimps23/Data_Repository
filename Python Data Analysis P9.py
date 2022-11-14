#!/usr/bin/env python
# coding: utf-8

# In[12]:


import pandas as pd
import numpy as num
import matplotlib.pyplot as plt
import os
from statistics import mean
df = pd.read_csv("C:\\Users\\Default\\Python\\car.data(1).csv")
pd.set_option('display.max_rows', 100)


# In[13]:


list(df.columns.values)


# In[14]:


df2 = df[df['doors'] != "5more"]
pd.DataFrame(df2)
mean(df2['doors'].astype(int))


# In[15]:


df3 = df[(df['class'] == 'good') & (df['doors'] != '5more')]
pd.DataFrame(df3)
mean(df3['doors'].astype(int))


# In[16]:


df['buying'].unique()


# In[17]:


df4 = df[df['persons'] == 'more']
len(df4.index)


# In[18]:


vhigh = df[df['buying'] == 'vhigh']
high = df[df['buying'] == 'high']
med = df[df['buying'] == 'med']
low = df[df['buying'] == 'low']
print(vhigh)
print(high)
print(med)
print(low)
vhigh


# In[19]:


df1 = pd.read_csv('C:\\Users\\Default\\Python\\analytic_v4Y2.csv')


# In[23]:


list(df1.columns.values)


# In[24]:


df1['Sex'].value_counts()


# In[25]:


df1.info()


# In[27]:


df1['AgeAtFirstClaim'].value_counts().plot.bar()


# In[44]:


df1[df1['Sex'] == 'F']['AgeAtFirstClaim'].value_counts().plot.bar()


# In[45]:


df1[df1['Sex'] == 'M']['AgeAtFirstClaim'].value_counts().plot.bar()


# In[74]:


df1.replace('40-49', 45, inplace = True)
df1.replace('50-59', 55, inplace = True)
df1.replace('60-69', 65, inplace = True)
df1.replace('70-79', 75, inplace = True)
df1.replace('80+', 85, inplace = True)
df1.replace('10-19', 15, inplace = True)
df1.replace('20-29', 25, inplace = True)
df1.replace('30-39', 35, inplace = True)
df1.replace('0-9', 5, inplace = True)


# In[76]:


df1['AgeAtFirstClaim'].mean()

