<div id="center">
<table>
<tr><td valign="top">
</td>
<td valign="top">
<h1><IMG SRC="./Images/mail.gif" ALT="Contact" />[Caption]</h1>
<p class="describe">[Description]</p><br>
<form name="form1" method="post">
<? 
if ( isset ( $_GET['envoye'] ))
	{
	echo "[MailSentMessage] : <span id='message'><br>".$_GET['envoye']."<br></span>" ;
	}
if ( isset ($txt_envoi ))
	{
	echo $txt_envoi ;
	}
?>
<br>
<table border="0">
<tr>
<td>[Name] :</td>
<td><input name="nom" type="text" id="nom" value="<? echo $_POST['nom'];?>"><font> [Surname] : </font><input name="prenom" type="text" id="prenom" value="<? echo $_POST['prenom'];?>">
</td>
</tr>
<tr>
<td>[MailFrom] :</td>
<td><input name="de1" type="text" id="de1" value="<? echo $_POST['de1'];?>">@<input name="de2" type="text" id="de2" value="<? echo $_POST['de2'];?>">
</td>
</tr>
<tr>
<td>[MailSubject] :</td>
<td><input name="sujet" type="text" id="sujet2" size="95" value="<? echo $_POST['sujet'];?>"></td>
</tr>
<tr>
<td>[Message] :</td>
<td><textarea name="message" cols="90" rows="5"><? echo $_POST['message'];?></textarea></td> </tr>
<tr>
<td>&nbsp;</td>
<td><input type="submit" name="Submit" value="[Send]">
<input type="reset" name="Submit2" value="[Reset]">
</form>
</td>
</tr>
</table>
</div>
<p>&nbsp; </p>
<br>
