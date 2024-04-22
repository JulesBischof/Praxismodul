#%% Innenwiderstand Spannungsversorgung
import numpy as np

## INPUT
l = 10 #m
A = 0.25 #mm2 
Rspez = 0.017 # ohm*mm / m; Kupfer
LoadReg = 1 #%
I_Netzteil = 20 #A
U_Netzteil = 24 #V
## CALC
R_Leitung = Rspez * (l / A)
R_Netzteil = ( U_Netzteil * (LoadReg/100) ) / I_Netzteil

Rtot = R_Leitung + R_Netzteil
print("Innenwiderstand: ", Rtot, " OHM")

#induktivität Leitung:
ur = 1 - 6.4e-6#Kuper
a = 2#mm
d = np.sqrt((4*A)/np.pi)

print("nur Kabel: ", R_Leitung, " OHM")



# https://www.sprut.de/electronic/kabel/kabel.htm

#%% grosses C für Versorgungsspannung - Ripple
import numpy as np

I = 2 # A
f = 20e3 # Hz
C = 520e-6 # F
U0  =24 # V
Rq = 102e-3 #OHM
Urip_gef = 25e-3 #V
t = 1/(2*f)
tau = Rq * C
Umin = I * Rq

Urip_calc = Umin*(1 - np.exp(-t/tau)) # Umin - Uc! 
C_ben = -t/(np.log(1 - (Urip_gef/Umin) ))

print("Ripple auf Versorung \n U = ", Urip_calc*1e3, "mV \n bei... \n C =",C*1e6,"uF \n R = ",Rq," Ohm \n f = ", f/1e3, "kHz")
print("ohne C vorraussichtlich U = ", Umin*1e3, " mV ")
print ("bei f = ",f*1e-3," kHz benötigtes C = ",C_ben*1e6," uF")













#%% C bei gegebenen L berechnen für Common Mode Dämpfung
import numpy as np

L = 3.9e-6 # F, Common Mode
fg = 100e3 # Hz

C = (1/L) * (1/(2*np.pi*fg))**2

print("bei einer Grenzfrequenz von ", fg*1e-3, " kHz", " L = ", L*1e-6, " mH \n muss C = ", C*1e6, " nF sein")

print("bei paralellschaltung muss also jedes C \n ", (C/2)*1e9, " nF gross sein")











#%% Filter 2.Ordnung Bode-Plot

import numpy as np
import matplotlib.pyplot as plt

# Parameter Filter
R = 0  # Ohm
L = 0.04e-6  # H
C = 10e-6  # F

# Frequenzbereich für den Bodeplot
frequencies = np.logspace(1, 6, 1000)  # log von 10 bis 10^6 Hz

# Amplitudengang
s = frequencies * 2 * np.pi * 1j
impedance = 1 / (s**2 * L * C + s*C*R + 1)

amplitude = np.abs(impedance)

# Erzeuge den Bodeplot
plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.semilogx(frequencies, 20 * np.log10(amplitude))
plt.title('LC-Bodeplot')
plt.ylabel('Amplitude (dB)')
plt.grid(True)

plt.show()







#%% Resonanz Dämpfen

# https://www.we-online.com/katalog/media/o108994v410%20AppNotes_ANP044_AuswirkungVonLayoutBauelementenUndFilterAufDieEMVVonModernenDCDCSchaltreglern_DE.pdf
# nach application Note
import numpy as np

Ci = 200e-9 # F paralell geschaltet! (LC-Glied Common Mode)
L = 32.8e-6 # H Common Mode
Q = 1 # Güte, gefordert

Cd = 4*Ci

n = Cd/Ci
zeta = 1/(np.sqrt(2))

Rd = ((n+1) / n) * (L / (2 * zeta * np.sqrt(L*Ci)))


print("nach Application Note benötigtes Rd = ", Rd, " OHM bei Cd = ", Cd*1e6, " uF")

print("Die Dämpfungen sind später paralell geschaltet. Die R's verdoppeln sich pro Strang, und die C's halbieren sich")
print("Re = ", 2*Rd, " OHM \nCe = ", (Cd/2)*1e6,"uF")








#%% Filter 2.Ordnung MIT DÄMPFUNGSKONDENSATOR Bode-Plot
import numpy as np
import matplotlib.pyplot as plt

# Parameter Basic-Filter
R = 0 #Ohm
L = 1.6e-6  # H
Ci = 1.6e-6  # F

# Dämpfung:
Cd = 6.4e-6 #F
Rd = 0.8 #OHM

# Frequenzbereich für den Bodeplot
frequencies = np.logspace(1, 6, 1000)  # log von 10 bis 10^6 Hz

# Amplitudengang
s = frequencies * 2 * np.pi * 1j

Zout = (1+Rd*Cd*s) / (Cd*s + Ci*s + Rd*Cd*Ci*(s**2))
Zin = R + s*L + Zout

impedance = Zout / Zin

amplitude = np.abs(impedance)

# Erzeuge den Bodeplot
plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.semilogx(frequencies, 20 * np.log10(amplitude))
plt.title('LC-Bodeplot')
plt.ylabel('Amplitude (dB)')
plt.grid(True)

plt.show()




















#%% Differential Mode Filter C berechnen bei gegebenen L

import numpy as np

# Parameter Basic-Filter
R = 0 #Ohm
L = 3.9e-6 # H, Common Mode
fg = 60e3 # Hz

Ci = (1/L) * (1/(2*np.pi*fg))**2

print("bei einer Grenzfrequenz von ", fg*1e-3, " kHz", " L = ", L*1e-6, " uH \n muss C = ", Ci*1e6, " uF sein")

import matplotlib.pyplot as plt

# Dämpfung:
L = 1.6e-6 # H Common Mode
Q = 1 # Güte, gefordert
Cd = 4*Ci
n = Cd/Ci
zeta = 1/(np.sqrt(2))
Rd = ((n+1) / n) * (L / (2 * zeta * np.sqrt(L*Ci)))



# Frequenzbereich für den Bodeplot
frequencies = np.logspace(1, 6, 1000)  # log von 10 bis 10^6 Hz

# Amplitudengang
s = frequencies * 2 * np.pi * 1j

Zout = (1+Rd*Cd*s) / (Cd*s + Ci*s + Rd*Cd*Ci*(s**2))
Zin = R + s*L + Zout

impedance = Zout / Zin
amplitude = np.abs(impedance)

# Erzeuge den Bodeplot
plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.semilogx(frequencies, 20 * np.log10(amplitude))
plt.title('LC-Bodeplot')
plt.ylabel('Amplitude (dB)')
plt.grid(True)

plt.show()


print("Differential Mode Filter: ")
print("Grenzfrequenz fg = ", fg*1e-3, "kHz")
print("Ci = ", Ci*1e6, " uF")
print("Cd = ", Cd*1e6, " uF")
print("Rd = ", Rd, " OHM")














#%% Filter 2.Ordnung Grenzfrequenz berechnen
import numpy as np

L = 360e-9 #H
C = 10e-6 #F

fg = 1/(2*np.pi*np.sqrt(L*C))

print("fg = ", fg/1e3, "kHz")