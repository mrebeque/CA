<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $oldUmask = umask(0002);

    $nomeArquivo = basename($_FILES['file']['name']);
    $nomeSemExtensao = pathinfo($nomeArquivo, PATHINFO_FILENAME);
    $extensao = strtolower(pathinfo($nomeArquivo, PATHINFO_EXTENSION));

    $urlCertificado = ' {{URL_CERTIFICADO}}' . '/' . $nomeSemExtensao . '/';
    $uploadDir = '{{DIR_SOLICITACOES}}';
    
    $extensoesPermitidas = ['req'];    
    if (!in_array($extensao, $extensoesPermitidas)) {
 			$param = ['status' => 'erro','arquivo' => $nomeArquivo,'descricao' => 'Erro: O arquivo de solicitação de certificado deve ter a extensão req'];			
      $retorno = 'Location: upload.html?' . http_build_query($param);
    }  else {

		  $tamanhoMaximo = 1024 * 1024; // 1MB em bytes
		  if ($_FILES['file']['size'] > $tamanhoMaximo) {
	 			$param = ['status' => 'erro','arquivo' => $nomeArquivo,'descricao' => 'Erro: Tamanho máximo permitido é de 1MB'];			
		    $retorno = 'Location: upload.html?' . http_build_query($param);
		  } else {
		  
				$uploadFile = $uploadDir . '/' . $nomeArquivo;
				if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadFile)) {
					$retorno = 'Location: ' . $urlCertificado;
					sleep(3);
				} else {
		 			$param = ['status' => 'erro','arquivo' => $nomeArquivo,'descricao' => 'Erro: Não foi possivel realizar o upload.'];			
				  $retorno = 'Location: upload.html?' . http_build_query($param);
				}
			}	
    }
    header($retorno);
    umask($oldUmask);
    exit();
}
?>

