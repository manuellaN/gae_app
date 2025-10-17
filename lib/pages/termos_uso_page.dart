import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermosUsoPage extends StatelessWidget {
  const TermosUsoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B0B4E), Colors.black],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botão de voltar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text(
                            'Voltar',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.home, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Título
                Text(
                  'Termos de Uso',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Última atualização: 17 de Out. 2025',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9747FF),
                  ),
                ),
                const SizedBox(height: 16),

                // Texto introdutório
                Text(
                  'Estes Termos de Uso ("Termos") regem a utilização do sistema de gestão infraestrutural escolar, disponibilizado por meio de um aplicativo móvel e uma plataforma web, com o objetivo de melhorar a comunicação entre alunos e orientadores e gerenciar problemas infraestruturais observados no ambiente escolar. Ao acessar ou utilizar este sistema, você concorda em cumprir e estar vinculado a estes Termos.\n\nCaso não concorde com os Termos de Uso, não utilize o sistema.',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14, height: 1.4),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),

                // Linha divisória
                Container(
                  height: 2,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),

                // Cláusulas
                _buildClausula(
                  '1. Definições',
                  '• Sistema: O sistema gerenciador de problemas infraestruturais escolares, composto pelo aplicativo móvel (para representantes de sala) e pela plataforma web (para orientadores e administradores).\n• Usuário Representante: Aluno que atua como representante de sala e pode reportar problemas infraestruturais por meio do aplicativo móvel.\n• Orientador: Membro da equipe de orientação escolar responsável por gerenciar e monitorar os problemas reportados pelos alunos.\n• Administrador: Responsável pelo gerenciamento e administração do sistema, incluindo a configuração e manutenção do ambiente web.',
                ),
                _buildClausula(
                  '2. Objetivo do Sistema',
                  'O sistema foi desenvolvido para facilitar o reporte e gerenciamento de problemas infraestruturais no ambiente escolar. Ele permite que alunos, por meio de seus representantes de sala, reportem problemas observados no ambiente escolar, como cadeiras danificadas, mesas quebradas ou outras questões relacionadas à infraestrutura. Os orientadores podem então analisar, atribuir responsáveis e acompanhar a resolução dos problemas.',
                ),
                _buildClausula(
                  '3. Requisitos para Utilização',
                  'Usuários Representantes (Aplicativo Móvel):\n• Cadastro e Login: Para utilizar o sistema, o usuário deve se cadastrar e autenticar-se com suas credenciais.\n• Redefinição de Senha: Caso o usuário esqueça sua senha, ele pode redefini-la por meio do aplicativo.\n• Envio de Reportes: Os representantes podem descrever e anexar imagens dos problemas observados, além de indicar sua localização.\n\nOrientadores/Administradores (Plataforma Web):\n• Cadastro e Login: O orientador e administrador devem se cadastrar e autenticar-se para acessar as funcionalidades de gerenciamento.\n• Gerenciamento de Reportes: A plataforma permite que os orientadores analisem, respondam e alterem o status dos reportes, como "em andamento", "concluído" ou "cancelado".',
                ),
                _buildClausula(
                  '4. Obrigações do Usuário',
                  'O usuário concorda em:\n• Fornecer informações precisas e atualizadas durante o cadastro.\n• Manter a confidencialidade de suas credenciais de acesso.\n• Utilizar o sistema de maneira ética e responsável, respeitando a privacidade de outros usuários.\n• Não utilizar o sistema para fins ilegais ou prejudiciais.\n• Reportar apenas problemas reais e relevantes, com base na sua observação e experiência no ambiente escolar.',
                ),
                _buildClausula(
                  '5. Propriedade Intelectual',
                  'O sistema e todos os seus conteúdos, incluindo código, design, textos, imagens e demais materiais, são propriedade exclusiva da FIEB, protegidos por direitos autorais e outras leis de propriedade intelectual. O usuário concorda em não copiar, modificar, distribuir ou reproduzir qualquer conteúdo sem a autorização expressa do proprietário.',
                ),
                _buildClausula(
                  '6. Segurança e Privacidade',
                  'A segurança e a privacidade dos dados dos usuários são prioridade. O sistema coletará e armazenará informações pessoais necessárias para o funcionamento da plataforma, como nome, e-mail, e dados relativos ao reporte de problemas. As informações serão tratadas com confidencialidade e de acordo com as leis aplicáveis de proteção de dados pessoais.\n\n• Controle de Acesso: O sistema possui medidas de segurança para garantir que apenas usuários autenticados (representantes, orientadores e administradores) possam acessar as funcionalidades apropriadas.',
                ),
                _buildClausula(
                  '7. Limitação de Responsabilidade',
                  'A FIEB não se responsabiliza por:\n• Danos decorrentes do uso inadequado do sistema pelo usuário.\n• Falhas técnicas ou indisponibilidade do sistema que possam prejudicar a utilização temporária.\n• Qualquer perda de dados ou informações que não sejam de responsabilidade direta da plataforma.',
                ),
                _buildClausula(
                  '8. Alterações nos Termos de Uso',
                  'A FIEB se reserva o direito de modificar, a qualquer momento, estes Termos de Uso. Quaisquer alterações serão publicadas nesta página, e o uso contínuo do sistema após a modificação será considerado como aceitação dos novos Termos.',
                ),
                _buildClausula(
                  '9. Rescisão de Acesso',
                  'A FIEB pode, a seu critério, suspender ou encerrar o acesso de um usuário ao sistema a qualquer momento, caso o usuário viole estes Termos de Uso ou utilize o sistema de maneira indevida.',
                ),
                _buildClausula(
                  '10. Disposições Finais',
                  '• Lei Aplicável: Estes Termos de Uso são regidos pelas leis do [país ou estado], independentemente de qualquer princípio de conflitos de leis.\n• Resolução de Conflitos: Qualquer disputa decorrente da utilização do sistema será resolvida por meio de arbitragem, conforme as regras estabelecidas pela [instituição ou órgão competente].',
                ),
                _buildClausula(
                  '11. Aceitação dos Termos',
                  'Ao acessar ou utilizar o sistema, você reconhece que leu, entendeu e concorda com estes Termos de Uso. Se não concordar com os Termos, não utilize o sistema.\n\nSe tiver dúvidas sobre estes Termos de Uso, entre em contato conosco através de gaesystem@gmail.com.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget para criar cada cláusula
  Widget _buildClausula(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14, height: 1.4),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}