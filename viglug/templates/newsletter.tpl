{include file="header.tpl"}
    <div id="content">
      <div class="page" id="page-libri">
        <h1>Newsletter</h1>
        <p>Tramite questa pagina potrai iscriverti alla newsletter del ViGLug in modo da ricevere aggiornamenti sulle nostre iniziative ed incontri.</p>
		<p>Il volume di messaggi è decismanete basso (im edia una decina all'anno) ed all'occorrenza potrai disiscriverti in qualsiasi momento.</p>
		{if $status && $status == 'OK'}
		<p style="color:green;">Registrazione avvenuta con successo!</p>
		{/if}
		{if $status && $status == 'FAIL'}
		<p style="color:red;">Compila tutti i campi!</p>
		{/if}
		<form method="post" action="newsletter.php">
		  <p>Nome</p>
		  <p><input type="text" name="nome" /></p>
		  <p>Cognome</p>
		  <p><input type="text" name="cognome" /></p>
		  <p>Email</p>
		  <p><input type="text" name="email" /></p>
		  <p><input type="submit" value="Inscriviti alla newsletter"></p>		
		</form>
      </div>
    </div>
{include file="footer.tpl"}
