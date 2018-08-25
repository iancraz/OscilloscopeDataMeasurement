import pyvisa
rm = pyvisa.ResourceManager()
rm.list_resources()
osciloscopio = rm.open_resource('Insert Resource')
print(my_instrument.query('*IDN?'))
#Si esto imprime bien, seguimos

#Setear elosciloscopio para que mida lo que quiero
print(osciloscopio.query('Insert configuration'))
print(osciloscopio.query('Insert configuration'))
print(osciloscopio.query('Insert configuration'))
print(osciloscopio.query('Insert configuration'))
print(osciloscopio.query('Insert configuration'))
###


valoresAscii = osciloscopio.query_ascii_values('Insert Measure') #Hay q ver que comando del osciloscopio va aca
valoresBinarios = osciloscopio.query_binary_values('Insert Measure', datatype='d', is_big_endian=True) #Hay q ver si esto esta bien

#Hay q ver que devuelve el osciloscopio a partir de aca
