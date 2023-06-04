unit CentroCustoModel;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  LancamentoModel;  // Unidade onde o TLancamento � definido

type
  TCentroCusto = class
  private
    FCodigoPai: Integer;
    FCodigoFilho: Integer;
    FLancamentos: TObjectList<TLancamento>;
  public
    property CodigoPai: Integer read FCodigoPai write FCodigoPai;
    property CodigoFilho: Integer read FCodigoFilho write FCodigoFilho;
    property Lancamentos: TObjectList<TLancamento> read FLancamentos;

    constructor Create(const CodigoPai, CodigoFilho: Integer);
    destructor Destroy; override;
    function GetCodigoCompleto: string;
    function GetValorTotal: Real;

    procedure AdicionarLancamento(const Lancamento: TLancamento);
  end;

implementation

constructor TCentroCusto.Create(const CodigoPai, CodigoFilho: Integer);
begin
  if (CodigoPai < 1) or (CodigoPai > 99) then
    raise Exception.Create('C�digo de centro de custo pai inv�lido.');
  if (CodigoFilho < 1000) or (CodigoFilho > 9999) then
    raise Exception.Create('C�digo de centro de custo filho inv�lido.');

  FCodigoPai := CodigoPai;
  FCodigoFilho := CodigoFilho;
  FLancamentos := TObjectList<TLancamento>.Create;
end;

destructor TCentroCusto.Destroy;
begin
  FLancamentos.Free;
  inherited;
end;

procedure TCentroCusto.AdicionarLancamento(const Lancamento: TLancamento);
begin
  if Lancamento.CodigoPai <> FCodigoPai then
    raise Exception.Create('O lan�amento n�o corresponde ao c�digo pai deste centro de custo.');

  if Lancamento.CodigoFilho <> FCodigoFilho then
    raise Exception.Create('O lan�amento n�o corresponde ao c�digo filho deste centro de custo.');

  FLancamentos.Add(Lancamento);
end;


function TCentroCusto.GetCodigoCompleto: string;
begin
  Result := Format('%.2d%.4d', [FCodigoPai, FCodigoFilho]);
end;

function TCentroCusto.GetValorTotal: Real;
var
  Lancamento: TLancamento;
begin
  Result := 0;
  for Lancamento in FLancamentos do
    Result := Result + Lancamento.Valor;
end;

end.

