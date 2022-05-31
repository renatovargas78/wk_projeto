program ProjetoTesteWK;

uses
  Vcl.Forms,
  uProjetoTeste in 'uProjetoTeste.pas' {FrmPrincipal},
  uConexao in 'Classes\uConexao.pas',
  uClientes in 'Classes\uClientes.pas',
  uFuncoes in 'Classes\uFuncoes.pas',
  uProdutos in 'Classes\uProdutos.pas',
  uProdutosPedidos in 'Classes\uProdutosPedidos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
