# === ! IMPORTANT ! ===========================================================
#
# Redirect Operators in PowerShell are syntax sugar -- they call Out-File and
#  Out-File -Append
#
# Out-File default encodes files to UTF16-BE -- this is not very portable
#
# Set-Content and Add-Content both default to ASCII, which is highly portable
#  They also allow you to specifiy the output encoding
#
# And so, while readablility favors the use of redirects, for file write and
#  append ops, use Set- and Add-Content instead of '>' and '>>'
#
# === ! IMPORTANT ! ===========================================================

# === ^ EXCEPTION ^ ===========================================================
#
# Redirects to null are favored over pipes to Out-null
#
# They essentially complete the same task (supression of output), but Out-null
#  defaults to a streamed loop of null calls
#
# Casting .NET operations to [Void] and redirecting completed operations to
#  null are prefered -- assigning operations to null is also a method
#
# === ^ EXCEPTION ^ ===========================================================

# === NOTE ====================================================================
#
# Gina favors short-circuiting a lot -- I turn a lot of those sc's into if-else
#  statements for readability
#
# Some sc are retained -- to supress output of sc in PowerShell, you have to
#  redirect output to a variable or null
#
# === NOTE ====================================================================
