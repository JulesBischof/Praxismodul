#%% Innenwiderstand Spannungsversorgung

## INPUT
l = 2 #m
A = 0.75 #mm2 
Rspez = 0.017 # ohm*mm / m; Kupfer

LoadReg = 1 #%
I_Netzteil = 20 #A
U_Netzteil = 24 #V


## CALC
R_Leitung = Rspez * (l / A)
R_Netzteil = ( U_Netzteil * (LoadReg/100) ) / I_Netzteil

Rtot = R_Leitung + R_Netzteil
print("Innenwiderstand: ", Rtot, " OHM")

#%% grosses C für Versorgungsspannung - Ripple
import numpy as np

I = 2 # A
f = 20e3 # Hz
C = 210e-6 # F
U0  =24 # V
Rq = 0.05733333333333333

Urip = 100e-3 #V

t = 1/(2*f)
tau = R * C
dU = I * Rq

Uc = dU*(1 - np.exp(-t/tau))

C_ben = t / (-np.log(1 - (Urip/dU)) * R)

print("Ripple auf Versorung \n U = ", Uc*1e3, "mV \n bei... \n C =",C*1e6,"uF \n R = ",Rq," Ohm \n f = ", f/1e3, "kHz")
print("für ein Ripple von ", Urip*1e3, "m V \n ist ein C von ", C_ben * 1e6, " uH benötigt")

#%% Common Mode Filter
import numpy as np

L = 40e-6 #H
fg_gef = 300e3 #Hz

C = (1/(2*np.pi * fg_gef))**2 * (1/L)

print("für gegegebenes L und benötigtes fg resultierendes C = ", C*1e9, " nF")

#%% Filter 2.Ordnung Grenzfrequenz berechnen
import numpy as np

L = 40e-6 #H
C = 7.03e-9 #F

fg = 1/(2*np.pi*np.sqrt(L*C))

print("fg = ", fg/1e3, "kHz")

#%% Filter 2.Ordnung Bode-Plot
import numpy as np
import matplotlib.pyplot as plt

# Parameter Filter
R = 0  # Ohm
L = 40e-6  # H
C = 40e-9  # F

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

#%% Filter 2.Ordnung MIT DÄMPFUNGSKONDENSATOR Bode-Plot
import numpy as np
import matplotlib.pyplot as plt

# Parameter Basic-Filter
R = 0  # Ohm
L = 40e-6  # H
C = 40e-9  # F

# Dämpfung:
Cd = 200e-9 #F
Rd = 25 #OHM

# Frequenzbereich für den Bodeplot
frequencies = np.logspace(1, 6, 1000)  # log von 10 bis 10^6 Hz

# Amplitudengang
s = frequencies * 2 * np.pi * 1j

Zl = R + L*s
Zc = (Rd * Cd * s + 1) / (Cd*s + Rd*C*Cd*s**2 + C*s)

impedance = Zc / (Zl + Zc)

amplitude = np.abs(impedance)

# Erzeuge den Bodeplot
plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.semilogx(frequencies, 20 * np.log10(amplitude))
plt.title('LC-Bodeplot')
plt.ylabel('Amplitude (dB)')
plt.grid(True)

plt.show()