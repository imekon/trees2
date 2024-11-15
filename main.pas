unit main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, raylib, utils;

type

  { TTree }

  TTree = class
  private
    m_x, m_z: double;
  public
    constructor Create(x, z: double);
    procedure Draw;
  end;

  TTreeList = specialize TFPGList<TTree>;

  { TGame }

  TGame = class
  private
    m_camera: TCamera;
    m_trees: TTreeList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    procedure Draw3D;
    procedure Draw2D;
  end;

implementation

{ TTree }

constructor TTree.Create(x, z: double);
begin
  m_x := x;
  m_z := z;
end;

procedure TTree.Draw;
begin
  DrawCube(Vec3(m_x, 2.5, m_z), 0.4, 4, 0.4, BROWN);
  DrawCube(Vec3(m_x, 4, m_z), 3, 2, 3, GREEN);
end;

{ TGame }

constructor TGame.Create;
var
  x, y: integer;
  tree: TTree;

begin
  Randomize;

  m_camera.position := Vec3(0, 2, 4);
  m_camera.target := Vec3(0, 2, 0);
  m_camera.up := Vec3(0, 1, 0);
  m_camera.fovy := 60;
  m_camera.projection := CAMERA_PERSPECTIVE;

  DisableCursor;

  m_trees := TTreeList.Create;

  for y := 0 to 7 do
    for x := 0 to 7 do
      m_trees.Add(TTree.Create(x * 8 - 32 + 2 - Random * 4, y * 8 - 32 + 2 - Random * 4));
end;

destructor TGame.Destroy;
var
  tree: TTree;

begin
  for tree in m_trees do
    tree.Free;

  m_trees.Free;
  inherited Destroy;
end;

procedure TGame.Update;
var
  mx, my, mz: double;

begin
  mx := 0;
  my := 0;
  mz := 0;

  if (IsKeyDown(KEY_W) or IsKeyDown(KEY_UP)) then
    mx := mx + 0.1;

  if (IsKeyDown(KEY_S) or IsKeyDown(KEY_DOWN)) then
    mx := mx - 0.1;

  if (IsKeyDown(KEY_D) or IsKeyDown(KEY_RIGHT)) then
    my := my + 0.1;

  if (IsKeyDown(KEY_A) or IsKeyDown(KEY_LEFT)) then
    my := my - 0.1;

  if IsKeyDown(KEY_PAGE_UP) then
    mz := mz + 0.02;

  if IsKeyDown(KEY_PAGE_DOWN) then
    mz := mz - 0.02;

  UpdateCameraPro(@m_camera,
    Vec3(mx, my, mz),
    Vec3(GetMouseDelta().x * 0.05, GetMouseDelta().y * 0.05, 0),
    GetMouseWheelMove * 0.5);
end;

procedure TGame.Draw3D;
var
  tree: TTree;

begin
  BeginMode3D(m_camera);
    DrawPlane(Vec3(0, 0, 0), Vec2(100, 100), YELLOW);

    for tree in m_trees do
      tree.Draw;

  EndMode3D;
end;

procedure TGame.Draw2D;
begin
  DrawFPS(10, 10);
end;

end.

