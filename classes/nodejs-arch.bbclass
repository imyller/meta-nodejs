# Helper utilities for building Node.js

def nodejs_map_dest_cpu(target_arch, d):
    import re
    if   re.match('i.86$', target_arch): return 'ia32'
    elif re.match('x86_64$', target_arch): return 'x64'
    elif re.match('aarch64$', target_arch): return 'arm64'
    elif re.match('powerpc64$', target_arch): return 'ppc64'
    elif re.match('powerpc$', target_arch): return 'ppc'
    return target_arch

