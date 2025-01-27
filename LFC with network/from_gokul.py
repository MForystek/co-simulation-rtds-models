import socket
import struct
import time
import win32com.client
from win32com.client import CastTo

GTNetIP = '172.24.14.202'
Port = 7777

cli = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cli.connect((GTNetIP, Port))

time.sleep(0.1)


hyApp = win32com.client.Dispatch('HYSYS.Application')
hyApp.Visible = True
hyCase = hyApp.SimulationCases.Open('C:\\Users\\forystmj\\Documents\\RSCAD\\RTDS_USER_FX\\fileman\\LFC with network\\Alkaline_Electrolysis_Plant_Copy.hsc') #full path to the hsc file
hyCase.Activate()
hycol = hyCase.Flowsheet.Streams('Stack power')
#hycolfs = hycol.Flowsheet
#hycolfs.Run()
bdcolfs = CastTo(hycol, 'BackDoor')
#bdcolfs.SendBackDoorMessage(":Stop")
pCondVariable=bdcolfs.BackDoorVariable(':Power.500').Variable


a = []

def fetchsend():
    pcondeValue = pCondVariable.GetValue()
    print(f"{pcondeValue = }")
    dataout = [pcondeValue, 1234.258]
    cli.sendall(struct.pack('>ff', *dataout))
    data = cli.recv(4)  # 2 floats * 4 bytes each = 8 bytes
    if len(data) == 4:
        b = struct.unpack('>f', data)
        print(b)
        pCondVariable.SetValue(b[0])
        a.append(b)
    else:
        pass

try:
    while True:
        fetchsend()
        time.sleep(1)
except KeyboardInterrupt:
    cli.close()
    print("Exit!")
    exit()