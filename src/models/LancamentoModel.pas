unit LancamentoModel;

interface

uses
  System.SysUtils;

type
  TLancamento = class
  private
    FId: Integer;
    FCodigoPai: Integer;
    FCodigoFilho: Integer;
    FValor: Real;
    FIdOrcamento: Integer;
  public
    property Id: Integer read FId write FId;
    property CodigoPai: Integer read FCodigoPai write FCodigoPai;
    property CodigoFilho: Integer read FCodigoFilho write FCodigoFilho;
    property Valor: Real read FValor write FValor;
    property IdOrcamento: Integer read FIdOrcamento write FIdOrcamento;

    constructor Create(Id, CodigoPai, CodigoFilho, IdOrcamento: Integer; Valor: Real); overload;
    constructor Create(CodigoPai, CodigoFilho: Integer; Valor: Real; IdOrcamento: Integer); overload;
end;

implementation

constructor TLancamento.Create(CodigoPai, CodigoFilho: Integer; Valor: Real; IdOrcamento: Integer);
begin
  FId := Id;
  FCodigoPai := CodigoPai;
  FCodigoFilho := CodigoFilho;
  FValor := Valor;
end;

constructor TLancamento.Create(Id, CodigoPai, CodigoFilho, IdOrcamento: Integer; Valor: Real);
begin
  if (Valor <= 0) then
    raise Exception.Create('Valor de lan�amento inv�lido.');
  if (CodigoPai < 1) or (CodigoPai > 99) then
    raise Exception.Create('C�digo de centro de custo pai inv�lido.');
  if (CodigoFilho < 1) or (CodigoFilho > 9999) then
    raise Exception.Create('C�digo de centro de custo filho inv�lido.');

  FValor := Valor;
  FCodigoPai := CodigoPai;
  FCodigoFilho := CodigoFilho;
end;

end.

