Function Set-Password ($domain,$samaccountname,$oldPassword,$newpassword){
    ([adsi]"WinNT://$domain/$samaccountname,user").ChangePassword($oldPassword,$newpassword)
}
