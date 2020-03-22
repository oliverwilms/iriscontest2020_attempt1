Class DMLSS.Util
{

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod SendSimpleMessage(server As %Net.SMTP) As %List
{
  Set msg = ##class(%Net.MailMessage).%New()
  Set From=server.authenticator.UserName
  Set:From="" From="xxx@xxx.com"
  Set msg.From = From
  
  Do msg.To.Insert("oliverwilms@yahoo.com")
  //Do msg.Cc.Insert("yyy@yyy.com")
  //Do msg.Bcc.Insert("zzz@zzz.com")
  Set msg.Subject="Unique subject line here "_$H
  Set msg.IsBinary=0
  Set msg.IsHTML=0
  Do msg.TextData.Write("This is the message.")
  
  Set status=server.Send(msg)
  If $$$ISERR(status) {
    Do $System.Status.DisplayError(status)
    Write server.Error
    Quit ""
  }
  Quit server.FailedSend
}

ClassMethod HotPOPAsSMTP() As %Net.SMTP
{
  Set server=##class(%Net.SMTP).%New()
  Set server.smtpserver="smtp.hotpop.com"
  //HotPOP SMTP server uses the default port (25)
  Set server.port=25
  
  //Create object to carry authentication
  Set auth=##class(%Net.Authenticator).%New()
  Set auth.UserName="isctest@hotpop.com"
  Set auth.Password="123pass"
  
  Set server.authenticator=auth
  Set server.AuthFrom=auth.UserName
  Quit server
}

ClassMethod YPOPsAsSMTP() As %Net.SMTP
{
  Set server=##class(%Net.SMTP).%New()
  //local host acts as the server
  Set server.smtpserver="127.0.0.1"
  //YPOPs uses default port, apparently
  Set server.port=25
  
  //Create object to carry authentication
  Set auth=##class(%Net.Authenticator).%New()
  //YPOPs works with a Yahoo email account
  Set auth.UserName="isc.test@yahoo.com"
  Set auth.Password="123pass"
  
  Set server.authenticator=auth
  Set server.AuthFrom=auth.UserName
  Quit server
}

ClassMethod Test() As %Status
{
	Kill ^TEST
	Set server = ..HotPOPAsSMTP()
	Set ^TEST($I(^TEST),"server") = server
	Set ^TEST($I(^TEST)) = ..SendSimpleMessage(server)
	Quit $$$OK
}

}
