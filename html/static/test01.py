x = int(input('please input x:'))  
y = int(input('please input y:'))  
z = int(input('please input z:'))  
if x > y :  
    x, y = y, x  
if x > z :  
    x, z = z, x  
if y > z :  
    y, z = z, y  
print(x,y,z)  
while True:
    pass 
