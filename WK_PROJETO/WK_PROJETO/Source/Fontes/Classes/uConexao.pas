unit uConexao;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Intf;

type
  TConexao = class

  private
    FVendorLib: String;
    FServidor: String;
    FMsgErro: String;
    FSenha: String;
    FBase: String;
    FLogin: String;
    FPorta: String;
    FConexao: TFDConnection;

  public
    constructor Create(NomeConexao : TFDConnection);
    destructor Destroy; override;

    function conectar_banco: boolean;
    property Conexao   : TFDConnection Read FConexao Write FConexao;
    property Servidor  : String Read FServidor Write FServidor;
    property Base      : String Read FBase Write FBase;
    property Login     : String Read FLogin Write FLogin;
    property Senha     : String Read FSenha Write FSenha;
    property Porta     : String Read FPorta Write FPorta;
    property MsgErro   : String Read FMsgErro Write FMsgErro;
    property VendorLib : String Read FVendorLib Write FVendorLib;
end;

implementation

uses
  System.SysUtils;


function TConexao.conectar_banco: boolean;
begin
  Result := True;
  FConexao.Params.Clear;
  FConexao.Params.Add('Server=' + FServidor);
  FConexao.Params.Add('user_name=' + FLogin);
  FConexao.Params.Add('password='+ FSenha);
  FConexao.Params.Add('port='+ FPorta);
  FConexao.Params.Add('Database='+FBase);
  FConexao.Params.Add('DriverID='+'MySQL');

  try
   FConexao.Connected := True;
  except
    on e:Exception do
    begin
      FMsgErro := e.Message;
      Result := False;
    end;
  end;
end;

constructor TConexao.Create(NomeConexao: TFDConnection);
begin
  FConexao := NomeConexao;
end;

destructor TConexao.Destroy;
begin
  FConexao.Connected := False;
  inherited;
end;

end.
