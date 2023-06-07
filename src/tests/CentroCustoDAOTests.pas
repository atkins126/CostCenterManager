unit CentroCustoDAOTests;

interface

uses
  DUnitX.TestFramework,
  CentroCustoModel,
  CentroCustoDAO,
  System.Generics.Collections,
  DBConn,
  DBConfig,
  OrcamentoDAO,
  OrcamentoModel;

type
  [TestFixture]
  TCentroCustoDAOTest = class(TObject)
  private
    FCentroCustoDAO: TCentroCustoDAO;
    FOrcamentoDAO: TOrcamentoDAO;  // Adicione uma vari�vel para o DAO de or�amento
    FCentroCusto: TCentroCusto;
    FOrcamentos: TObjectList<TOrcamentoModel>;  // Alterado para uma lista de or�amentos
    DBConfig: TDBConfig;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    [Test]
    procedure TestInsertAndSelect;
    [Test]
    procedure TestUpdate;
    [Test]
    procedure TestDelete;
    [Test]
    procedure TestGetAll;
  end;

implementation

procedure TCentroCustoDAOTest.SetUp;
begin
  DBConfig := TDBConfig.Create('C:\Users\Vinicius Ribeiro\Documents\Projetos\CostCenterManager\database\DATABASE.FDB',
                                 'sysdba',
                                 'masterkey',
                                 'localhost',
                                 '3050');

  TDBConn.SetConfig(DBConfig);

  FOrcamentoDAO := TOrcamentoDAO.Create;  // Crie o DAO de or�amento
  FCentroCustoDAO := TCentroCustoDAO.Create;

  FOrcamentos := TObjectList<TOrcamentoModel>.Create;  // Inicie a lista de or�amentos

  // Crie e insira alguns registros de or�amento
  FOrcamentos.Add(FOrcamentoDAO.Insert); // Insere um or�amento e adiciona na lista
  FOrcamentos.Add(FOrcamentoDAO.Insert); // Repita para cada ID de or�amento necess�rio
  FOrcamentos.Add(FOrcamentoDAO.Insert);
  FOrcamentos.Add(FOrcamentoDAO.Insert);

  // Agora, voc� pode criar e inserir os registros de CentroCusto com seguran�a
  FCentroCustoDAO.Insert(TCentroCusto.Create(10, 2000, FOrcamentos[0].Id));
  FCentroCustoDAO.Insert(TCentroCusto.Create(20, 3000, FOrcamentos[1].Id));
  FCentroCustoDAO.Insert(TCentroCusto.Create(30, 4000, FOrcamentos[2].Id));

  FCentroCusto := TCentroCusto.Create(40, 2000, FOrcamentos[3].Id);
end;

procedure TCentroCustoDAOTest.TearDown;
begin
  // Libere a lista de or�amentos
  FOrcamentos.Free;
  FCentroCustoDAO.Free;
  FOrcamentoDAO.Free;  // N�o esque�a de liberar o DAO de or�amento
  DBConfig.Free;
end;

procedure TCentroCustoDAOTest.TestInsertAndSelect;
var
  NewCentroCusto: TCentroCusto;
begin
  // Test Insert
  Assert.IsTrue(FCentroCustoDAO.Insert(FCentroCusto), 'Failed on Insert');

  // Test Select
  NewCentroCusto := FCentroCustoDAO.Select(FCentroCusto.CodigoPai, FCentroCusto.CodigoFilho);
  try
    Assert.IsNotNull(NewCentroCusto, 'Failed on Select');
    Assert.AreEqual(FCentroCusto.CodigoPai, NewCentroCusto.CodigoPai, 'CodigoPai does not match');
    Assert.AreEqual(FCentroCusto.CodigoFilho, NewCentroCusto.CodigoFilho, 'CodigoFilho does not match');
    Assert.AreEqual(FCentroCusto.IdOrcamento, NewCentroCusto.IdOrcamento, 'IdOrcamento does not match');  // Verifica a igualdade do campo IdOrcamento
  finally
    NewCentroCusto.Free;
  end;
end;

procedure TCentroCustoDAOTest.TestUpdate;
begin
  Assert.IsTrue(FCentroCustoDAO.Update(FCentroCusto), 'Failed on Update');
end;

procedure TCentroCustoDAOTest.TestDelete;
begin
  Assert.IsTrue(FCentroCustoDAO.Delete(FCentroCusto), 'Failed on Delete');
end;

procedure TCentroCustoDAOTest.TestGetAll;
var
  CentroCustos: TObjectList<TCentroCusto>;
begin
  CentroCustos := FCentroCustoDAO.GetAll;
  try
    Assert.IsTrue(CentroCustos.Count > 0, 'No CentroCustos found');
  finally
    CentroCustos.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TCentroCustoDAOTest);

end.

