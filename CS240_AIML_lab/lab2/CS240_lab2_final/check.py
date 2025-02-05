class my_class:
    def __init__(self,f,a):
        self.a = a
        self.f = f(a)

def fun(a):
    return a +1

Hii = my_class(fun,2)
print(Hii.f)
