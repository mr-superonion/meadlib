# Measured BAHAMAS power spectra file names
def power_file_name(mesh, model, snap, field_pair):
    dir = '/Users/Mead/Physics/BAHAMAS/power'
    field1 = field_pair[0]
    field2 = field_pair[1]
    return dir+'/M'+str(mesh)+'/'+model+'_L400N1024_WMAP9_snap'+str(snap)+'_'+field1+'_'+field2+'_power.dat'

# Measured BAHAMAS errors between different realisations of the AGN_TUNED_nu0 model
def error_file_name(mesh, snap, field_pair):
    dir = '/Users/Mead/Physics/BAHAMAS/power'
    field1 = field_pair[0]
    field2 = field_pair[1]
    return dir+'/M'+str(mesh)+'/L400N1024_WMAP9_snap'+str(snap)+'_'+field1+'_'+field2+'_error.dat'

   # Get the snapshot number corresponding to different BAHAMAS redshifts
def z_to_snap(z):
    if(z == 0.000):
        snap = 32
    elif(z == 0.125):
        snap = 31
    elif(z == 0.250):
        snap = 30
    elif(z == 0.375):
        snap = 29
    elif(z == 0.500):
        snap = 28
    elif(z == 0.750):
        snap = 27
    elif(z == 1.000):
        snap = 26
    elif(z == 1.250):
        snap = 25
    elif(z == 1.500):
        snap = 24
    elif(z == 1.750):
        snap = 23
    elif(z == 2.000):
        snap = 22
    else:
        print('Redshift = ', z)
        raise ValueError('Snapshot not stored corresponding to this z')
    return snap

# Read a BAHAMAS power/error file and output k, power, error
def get_measured_power(mesh, model, z, field_pair, errors=1):
   from numpy import loadtxt
   snap = z_to_snap(z)
   infile = power_file_name(mesh, model, snap, field_pair)
   data = loadtxt(infile)
   k = data[:,0]
   power = data[:,1]
   if (errors == 1):
      error = data[:,4]
   elif(errors == 2):
      infile = error_file_name(mesh, snap, field_pair)
      data = loadtxt(infile)
      error = data[:,1]
   else:
      raise ValueError('Something went wrong trying to get the BAHAMAS error bars')
   return k, power, error

def get_measured_response(mesh, model, z, field_pair):
   k, power, _ = get_measured_power(mesh, model, z, field_pair, errors=1)
   dmonly_name = 'DMONLY_2fluid_nu0'
   _, dmonly, _ = get_measured_power(mesh, dmonly_name, z, field_pair=('all', 'all'), errors=1)
   response = power/dmonly
   return k, response

