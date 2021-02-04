unit RiggVar.FZ.Z23_Federgraph;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.Math.Vectors,
  System.Types,
  RiggVar.FD.Elements;

{$define WantDiameter}

type
  TFederFormulaBase = class
  protected
    FSpringCount: Integer;
  public
    rmin: single;
    rmax: single;
    constructor Create; virtual;
    function GetValue(x, y: single): single; virtual;
    procedure PrepareCalc; virtual;
    property SpringCount: Integer read FSpringCount write FSpringCount;
  end;

  TFederEquation = class(TFederFormulaBase)
  private
    function GetSampleInfo: string;
  protected
    function Kraft(k, l, l0: single): single;
    function Force(k, l, l0: single; m: Integer): single;
  public
    FaktorEQ: Integer;
    SourceFormat: Integer;

    ErrorCounter: Integer;
    HasError: Boolean;

    MaxPlotFigure: Integer;

    a1, a2, a3, a4: single;
    b1, b2, b3, b4: single;
    t1, t2, t3, t4: single;
    f1, f2, f3, f4: single;

    d: single;
    d1, d2, d3, d4: single;
    fx, fy: single;

    m1, m2, m3, m4: Integer;
    x1, x2, x3, x4: single;
    y1, y2, y3, y4: single;
    z1, z2, z3, z4: single;
    l1, l2, l3, l4: single;
    k1, k2, k3, k4: single;
    iv, iw, jv, jw: single;

    y3f: single;
    l3f: single;
    Lf: single;

    fcap: single;
    pcap: Integer;
    mcap: Integer;

    Gain: Integer;
    Limit: Integer;
    Figure: Integer;
    Plot: Integer;
    Dim: Integer;

    PlusCap: Boolean;
    MinusCap: Boolean;

    Vorzeichen: Boolean;
    SolutionMode: Boolean;
    LinearForce: Boolean;
    ForceMode: Integer;
    SliceMode: Integer;
    DiffMode: Integer;
    PlotFigure: Integer;
    WantDiff: Boolean;
    WantDiffOnce: Boolean;

    OffsetZ: Integer;

    Hub: Integer;
    Sample: Integer;

    constructor Create; override;

    function GetValue(x, y : single): single; override;
    procedure PrepareCalc; override;

    procedure InitFormula;
    function CalcFederFormula(x, y: single): single;

    procedure InitKoord; virtual;
    procedure InitFaktorEQ;
    procedure InitMaxPlotFigure;
    function GetStatusLine: string; virtual;
    property SampleInfo: string read GetSampleInfo;
  end;

  TFederPoly = class
  private
    function RotateDegrees(ov: TPoint3D; wi: single): TPoint3D;
  public
    WantLL: Boolean;
    LL: TPolygon;
    D1: TPointF;
    D2: TPointF;

    WantLC: Boolean;
    LC: TPolygon;

    LLCount: Integer;
    LCCount: Integer;

    WantDash: Boolean;
    sw1: single;
    sw2: single;

    ParamBahnRadius: single;
    ParamBahnPosition: TPoint3D;
    ParamBahnAngle: single;

    EQ: TFederEquation;

    Flip: single;

    constructor Create;
    destructor Destroy; override;

    procedure UpdateSize;
    procedure InitLL;
    procedure InitLC;
    procedure Compute;
  end;

  TRggDrawingZ23 = class(TRggDrawing)
  private
    Raster: single;
    FederModel: TFederPoly;
    WantLC: Boolean;
    function GetHelpText: string;
    procedure Btn1Click(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
  public
    A: TRggCircle;
    B: TRggCircle;
    C: TRggCircle;
    D: TRggCircle;
    AD: TRggFederLine;
    BD: TRggFederLine;
    CD: TRggFederLine;
    HT: TRggLabel;

    Circle: TRggBigCircle;

{$ifdef WantDiameter}
    D1: TRggCircle;
    D2: TRggCircle;
    Diameter: TRggLine;
{$endif}

    Poly: TRggPolyCurve;

    ParamA: TRggParam;
    ParamR: TRggParam;

    constructor Create;
    destructor Destroy; override;

    procedure InitDefaultPos; override;
    procedure Compute; override;
    procedure InitButtons(BG: TRggButtonGroup); override;
  end;

implementation

{ TRggDrawingZ23 }

procedure TRggDrawingZ23.InitDefaultPos;
var
  ox, oy, oz: single;
  r, t: single;
begin
  ParamA.ParamValue := ParamA.BaseValue;
  ParamR.ParamValue := ParamR.BaseValue;

  ox := 400;
  oy := 400;
  oz := 0;

  r := 200;
  t := r * tan(pi/3) / 2;
  A.Center.X := ox - r;
  A.Center.Y := oy + t;
  A.Center.Z := oz;

  B.Center.X := ox + r;
  B.Center.Y := oy + t;
  B.Center.Z := oz;

  C.Center.X := ox;
  C.Center.Y := oy - t;
  C.Center.Z := oz;

  D.Center.X := ox;
  D.Center.Y := oy;
  D.Center.Z := oz;

  Circle.Center := D.Center;

  FederModel.ParamBahnRadius := 100;
  FederModel.ParamBahnPosition := D.Center.C;
  FederModel.ParamBahnAngle := 0;

{$ifdef WantDiameter}
  D1.Center := D.Center;
  D1.Center.X := D1.Center.X - FederModel.ParamBahnRadius;

  D2.Center := D.Center;
  D2.Center.X := D2.Center.X + FederModel.ParamBahnRadius;
{$endif}
end;

constructor TRggDrawingZ23.Create;
begin
  inherited;
  Name := 'Z23-Federgraph';

  Raster := 25;

  { Points }

  A := TRggCircle.Create('A');
  A.StrokeColor := TRggColors.Red;

  B := TRggCircle.Create('B');
  B.StrokeColor := TRggColors.Green;

  C := TRggCircle.Create('C');
  C.StrokeColor := TRggColors.Blue;

  D := TRggCircle.Create('D');
  D.StrokeColor := TRggColors.Dodgerblue;

  AD := TRggFederLine.Create('AD');
  AD.Point1 := A;
  AD.Point2 := D;
  AD.ShowCaption := False;
  AD.StrokeThickness := 2;
  AD.StrokeColor := TRggColors.Aquamarine;

  BD := TRggFederLine.Create('BD');
  BD.Point1 := B;
  BD.Point2 := D;
  BD.ShowCaption := False;
  BD.StrokeThickness := 2;
  BD.StrokeColor := TRggColors.Aquamarine;

  CD := TRggFederLine.Create('CD');
  CD.Point1 := C;
  CD.Point2 := D;
  CD.ShowCaption := False;
  CD.StrokeThickness := 2;
  CD.StrokeColor := TRggColors.Aquamarine;

  HT := TRggLabel.Create;
  HT.Caption := 'HelpText';
  HT.Text := GetHelpText;
  HT.StrokeColor := TRggColors.Tomato;
  HT.IsMemoLabel := True;
  Add(HT);

  FederModel := TFederPoly.Create;

  Circle := TRggBigCircle.Create('Path');
  Circle.StrokeThickness := 1;
  Circle.StrokeColor := TRggColors.Plum;
  Circle.Radius := FederModel.ParamBahnRadius;
  Circle.IsComputed := True;
  Circle.ShowCaption := False;
  Add(Circle);

{$ifdef WantDiameter}
  D1 := TRggCircle.Create('D1');
  D1.StrokeColor := TRggColors.Dodgerblue;
  D1.ShowCaption := False;
  D1.IndentItem := True;
  Add(D1);

  D2 := TRggCircle.Create('D2');
  D2.StrokeColor := TRggColors.Dodgerblue;
  D2.ShowCaption := False;
  D2.IndentItem := True;
  Add(D2);

  Diameter := TRggLine.Create('Diameter');
  Diameter.Point1 := D1;
  Diameter.Point2 := D2;
  Diameter.ShowCaption := False;
  Diameter.IndentItem := True;
  Diameter.StrokeThickness := 1;
  Diameter.StrokeColor := TRggColors.Dodgerblue;
  Add(Diameter);
{$endif}

  Poly := TRggPolyCurve.Create('Poly', Length(FederModel.LC));
  Poly.Caption := 'Poly';
  Poly.StrokeThickness := 3;
  Poly.StrokeColor := TRggColors.Plum;
  Poly.Opacity := 1.0;
  Add(Poly);

  ParamA := TRggParam.Create;
  ParamA.Caption := 'Probe Angle';
  ParamA.StrokeColor := TRggColors.Teal;
  ParamA.StartPoint.Y := 3 * Raster;
  ParamA.Scale := 1;
  ParamA.BaseValue := 0;
  Add(ParamA);

  ParamR := TRggParam.Create;
  ParamR.Caption := 'Probe Radius';
  ParamR.StrokeColor := TRggColors.Teal;
  ParamR.StartPoint.Y := 5 * Raster;
  ParamR.Scale := 1;
  ParamR.BaseValue := 100;
  Add(ParamR);

  InitDefaultPos;

  Add(A);
  Add(B);
  Add(C);
  Add(D);
  Add(AD);
  Add(BD);
  Add(CD);

  FixPoint3D := D.Center.C;
  WantRotation := False;
  WantSort := False;
  WantLC := True;

  DefaultElement := D;
end;

destructor TRggDrawingZ23.Destroy;
begin
  FederModel.Free;
  inherited;
end;

function TRggDrawingZ23.GetHelpText: string;
begin
  ML.Add('Federgraph Example (2D).');

  result := ML.Text;
  ML.Clear;
end;

procedure TRggDrawingZ23.Compute;
begin
  FederModel.ParamBahnAngle := ParamA.ParamValue;
  FederModel.ParamBahnRadius := ParamR.ParamValue;

  Circle.Center := D.Center;
  Circle.Radius := FederModel.ParamBahnRadius;

  FederModel.EQ.x1 := A.Center.X;
  FederModel.EQ.y1 := A.Center.Y;

  FederModel.EQ.x2 := B.Center.X;
  FederModel.EQ.y2 := B.Center.Y;

  FederModel.EQ.x3 := C.Center.X;
  FederModel.EQ.y3 := C.Center.Y;

  FederModel.ParamBahnPosition := D.Center.C;

  FederModel.Compute;

{$ifdef WantDiameter}
  Diameter.Point1.Center.P := FederModel.D1;
  Diameter.Point2.Center.P := FederModel.D2;
{$endif}

  if WantLC then
  begin
    Poly.AssignPoly(FederModel.LC);
  end
  else
  begin
    Poly.AssignPoly(FederModel.LL);
  end;

  ParamA.Text := Format('Param A = %.2f', [ParamA.ParamValue]);
  ParamR.Text := Format('Param R = %.2f', [ParamR.ParamValue]);
end;

procedure TRggDrawingZ23.InitButtons(BG: TRggButtonGroup);
begin
  { Will only be called if Buttons have been created. }
  inherited; { will call Reset }

  BG.Btn1.OnClick := Btn1Click;
  BG.Btn2.OnClick := Btn2Click;

  BG.Btn1.Text := 'LC';
  BG.Btn2.Text := 'LL';
end;

procedure TRggDrawingZ23.Btn1Click(Sender: TObject);
begin
  WantLC := True;
  Compute;
  TH.Draw;
end;

procedure TRggDrawingZ23.Btn2Click(Sender: TObject);
begin
  WantLC := False;
  Compute;
  TH.Draw;
end;

{ TFederFormulaBase }

constructor TFederFormulaBase.Create;
begin
  FSpringCount := 3;
end;

procedure TFederFormulaBase.PrepareCalc;
begin
  //virtual, do nothing here
end;

function TFederFormulaBase.GetValue(x, y: single): single;
begin
  result := sqr(x) * sqr(y);
end;

{ TFederEquation }

constructor TFederEquation.Create;
begin
  inherited Create;

  DiffMode := 2;
  Randomize;
  PlotFigure := 1;
  iv := 30;
  iw := 5;
  jv := 150;
  jw := 5;
  InitKoord;
end;

procedure TFederEquation.InitFormula;
begin
  x1 := 65;
  x2 := -65;
  x3 := 0;

  y1 := 65;
  y2 := 65;
  y3 := -65;

  z1 := 0;
  z2 := 0;
  z3 := 0;

  l1 := 90;
  l2 := 90;
  l3 := 90;

  k1 := 1;
  k2 := 1;
  k3 := 1;

  m1 := 0;
  m2 := 0;
  m3 := 0;

  ForceMode := 0;
end;

function TFederEquation.CalcFederFormula(x, y: single): single;
begin
  a1 := sqr(x-x1) + sqr(y-y1);
  a2 := sqr(x-x2) + sqr(y-y2);
  a3 := sqr(x-x3) + sqr(y-y3);

  t1 := sqrt(a1 + sqr(z1));
  t2 := sqrt(a2 + sqr(z2));
  t3 := sqrt(a3 + sqr(z3));

  b1 := t2 * t3 * (t1-l1) * k1;
  b2 := t1 * t3 * (t2-l2) * k2;
  b3 := t1 * t2 * (t3-l3) * k3;

  result := abs( (b1 * (x-x1) + b2 * (x-x2) + b3 * (x-x3)) / 1000000);
end;

function TFederEquation.GetSampleInfo: string;
begin
  if SpringCount > 4 then
  begin
    result := Format('/* Federgraph, Dim %d, Plot %d, Hub %d, Sample %d*/',
    [Dim, Plot, Hub, Sample]);
  end
  else
  begin
    result := Format('/* Federgraph, Scene %d, Plot %d, Hub %d, Sample %d*/',
    [SpringCount, Plot, Hub, Sample]);
  end;
end;

function TFederEquation.GetStatusLine: string;
begin
  result := '';
end;

function TFederEquation.GetValue(x, y: single): single;
begin
  result := CalcFederFormula(x, y);
end;

procedure TFederEquation.InitKoord;
begin
  InitFaktorEQ;
  InitMaxPlotFigure;
end;

procedure TFederEquation.InitFaktorEQ;
begin
  case SpringCount of
    1: FaktorEQ := 1;
    2: FaktorEQ := 1 * 1000;
    3: FaktorEQ := 100 * 1000;
    4: FaktorEQ := 500 * 1000;
    //EquationS FaktorEQ := 100 * 1000;
    else FaktorEQ := 800;
  end;
end;

procedure TFederEquation.InitMaxPlotFigure;
begin
  case SpringCount of
    1: MaxPlotFigure := 2;
    2: MaxPlotFigure := 13;
    3: MaxPlotFigure := 4;
    4: MaxPlotFigure := 4;
    //EquationS MaxPlotfigure := 4;
    else FaktorEQ := 4;
  end;
end;

function TFederEquation.Kraft(k, l, l0: single): single;
begin
  result := Force(k, l, l0, ForceMode);
end;

function TFederEquation.Force(k, l, l0: single; m: Integer): single;
begin
  if LinearForce then
    result := k * (l - l0)
  else
  begin
    //result := k * sqr(l - l0) * 0.02;
    result := k * sqr(l - l0) * 50;
    //result := 500 * k * Main.TrimmTab.EvalY((l-l0) / 20);
  end;
  case m of
    1:
    begin
      if result < 0 then
        result := 0;
    end;
    2:
    begin
      if result > 0 then
        result := 0;
    end;
  end;
end;

procedure TFederEquation.PrepareCalc;
var
  gain1: single;
  gain2: single;
  gain3: single;
  gain4: single;
begin
  gain1 := Abs(Gain);

  if gain1 < 1000 then
    gain2 := sqr(gain1 / 100) * 100 * 1000
  else
    gain2 := sqr(10) * 100 * 1000;

  case SpringCount of
    1: gain3 := 0.005;
    2: gain3 := 1;
    3: gain3 := 500;
    4: gain3 := 25;
    else
      gain3 := 1;
  end;

  gain4 := (1000 + gain2) * gain3;

  case Figure of
    1: fcap := gain4 * 0.1;
    2: fcap := gain4 * 1;
    3: fcap := gain4 * 10;
    4: fcap := gain4 * 100;
    5: fcap := gain4 * 1000;
  end;

  pcap := 100 + Limit;
  mcap := -pcap;
end;

{ TFederPoly }

constructor TFederPoly.Create;
var
  t: single;
begin
  { flip direction of of LL }
  Flip := -1;

  ParamBahnRadius := 100;
  ParamBahnPosition := TPoint3D.Create(400, 400, 0);
  ParamBahnAngle := 0;

  EQ := TFederEquation.Create;
  EQ.InitFormula;

  t := 90;
  EQ.l1 := t;
  EQ.l2 := t;
  EQ.l3 := t;

  t := 0.1;
  EQ.k1 := t;
  EQ.k2 := t;
  EQ.k3 := t;

  UpdateSize;
end;

destructor TFederPoly.Destroy;
begin
  EQ.Free;
  inherited;
end;

procedure TFederPoly.Compute;
begin
  InitLL;
  InitLC;
end;

procedure TFederPoly.UpdateSize;
begin
  LLCount := 100;
  LCCount := 360;
  SetLength(LL, LLCount + 1);
  SetLength(LC, LCCount + 1);
end;

procedure TFederPoly.InitLC;
var
  i: Integer;
  u, v: single;
  p: TPoint3D;
  phi: single;
  pstep: single;
  cphi: single;
  sphi: single;
  ox: single;
  oy: single;
begin
  ox := ParamBahnPosition.X;
  oy := ParamBahnPosition.Y;

  pstep := 2 * pi / LCCount;
  for i := 0 to LCCount do
  begin
    phi := i * pstep;

    cphi := cos(phi);
    sphi := sin(phi);

    u := ox + ParamBahnRadius * cphi;
    v := oy + ParamBahnRadius * sphi;

    p.Z := EQ.GetValue(u, v);
    p.X := ox + (ParamBahnRadius + p.Z) * cphi;
    p.Y := oy + (ParamBahnRadius + p.Z) * sphi;

    LC[i].X := p.X;
    LC[i].Y := p.Y;
  end;
end;

procedure TFederPoly.InitLL;
var
  i: Integer;
  Z: single;
  u, v: single;
  mx, ms: single;
  msx: single;
  ox, oy, wi: single;

  v0, v1, v2, v3, v4, v5, vx, vz: TPoint3D;
  f: single;
begin
  mx := ParamBahnRadius;
  ms := 2 * mx / LLCount;
  msx := ms;

  ox := ParamBahnPosition.X;
  oy := ParamBahnPosition.Y;
  wi := ParamBahnAngle;

  v0 := TPoint3D.Create(ox, oy, 0);
  v1 := TPoint3D.Create(1, 0, 0);
  vx := RotateDegrees(v1, wi);

  vz := RotateDegrees(v1, wi + 90);

  for i := 0 to LLCount do
  begin
    f := -mx + i * msx;
    v2 := vx * f;
    v3 := v0 + v2;

    u := v3.X;
    v := v3.Y;
    Z := EQ.GetValue(u, v);

    v4 := vz * Flip * Z;
    v5 := v3 + v4;

    if i = 0 then
    begin
      D1.X := u;
      D1.Y := v;
    end;
    if i = LLCount then
    begin
      D2.X := u;
      D2.Y := v;
    end;

    LL[i].X := v5.X;
    LL[i].Y := v5.Y;
  end;
end;

function TFederPoly.RotateDegrees(ov: TPoint3D; wi: single): TPoint3D;
var
  a: single;
  m: TMatrix3D;
begin
  a := DegToRad(DegNormalize(Abs(wi)));
  if wi >= 0 then
    m := TMatrix3D.CreateRotation(TPoint3D.Create(0, 0, 1), a)
  else
    m := TMatrix3D.CreateRotation(TPoint3D.Create(0, 0, -1), a);
  result := ov * m;
end;

end.
