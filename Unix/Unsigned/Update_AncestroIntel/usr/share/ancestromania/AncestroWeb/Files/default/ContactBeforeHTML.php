<? 
if ( isset ( $_POST['de1'] ) &&  isset ( $_POST['de2'] ) && isset ( $_POST['message'] ) && ( $_POST['message'] != "" ) && ( $_POST['de1'] != "" ) && ( $_POST['de2'] != "" ))
	{
	include_once ( "./Phpmailer/class.phpmailer.php" );

	$mails = new PHPMailer();
        include('./Phpmailer/language/phpmailer.lang-[Lang].php');
        $mails->language = $PHPMAILER_LANG;//	

	$mails->Mailer  = '[Mailer]';

	$mails->AddAddress("[Mail]", "[Author]");
	$mails->Body = $_POST['Message']; 
	$mails->Username = '[Username]'; 
	$mails->Password = '[Password]'; 
	$mails->Host = '[Host]'; 
	$mails->Port = [Port]; 
	$mails->SMTPSecure = '[Security]'; 
	$mails->SMTPAuth = [Identify];
	$mails->Subject = $_POST['sujet'];
	$mails->From = $_POST['de1']."@".$_POST['de2'];
	$mails->FromName = $_POST['nom']." ".$_POST['prenom'];

	$format = "txt";
	if ( $mails->Send())
		{
		echo ( '<html><head><META http-equiv="refresh" content="1; URL=[File]?envoye='.$_POST['sujet'].'"></head></html>'); 
		exit;
		}
	   else
		{
		$txt_envoi = "<b>Erreur</b> dans l'envoi du mail :".$mails->ErrorInfo."<br>Sujet : ".$_POST['sujet']."<br>Message : ".$_POST['message']."<br>";
		}
	}

?>

