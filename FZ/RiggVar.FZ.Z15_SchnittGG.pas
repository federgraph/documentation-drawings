unit RiggVar.FZ.Z15_SchnittGG;

interface

uses
  System.Math.Vectors,
  RiggVar.FD.Elements;

type
  TRggDrawingZ15 = class(TRggDrawing)
  private
    function GetHelpText: string;
    function SchnittGG(P1, P2, P3, P4: TPoint3D; out SP: TPoint3D): Boolean;
  public
    A: TRggCircle;
    B: TRggCircle;
    C: TRggCircle;
    D: TRggCircle;
    S: TRggCircle;
    HT: TRggLabel;
    constructor Create;
    procedure InitDefaultPos; override;
    procedure Compute; override;
  end;

implementation

{ TRggDrawingZ15 }

procedure TRggDrawingZ15.InitDefaultPos;
var
  ox, oy: single;
begin
  ox := 400;
  oy := 400;

  A.Center.X := ox - 200;
  A.Center.Y := oy;
  A.Center.Z := 0;

  B.Center.X := ox + 200;
  B.Center.Y := oy;
  B.Center.Z := 0;

  C.Center.X := ox;
  C.Center.Y := oy - 200;
  C.Center.Z := 0;

  D.Center.X := ox;
  D.Center.Y := oy + 200;
  D.Center.Z := 0;

  S.Center.C := TPoint3D.Zero;
end;

procedure TRggDrawingZ15.Compute;
var
  P1, P2: TPoint3D;
  P3, P4: TPoint3D;
  SP: TPoint3D;
begin
  P1.X := A.Center.X;
  P1.Z := A.Center.Y;
  P2.X := B.Center.X;
  P2.Z := B.Center.Y;

  P3.X := C.Center.X;
  P3.Z := C.Center.Y;
  P4.X := D.Center.X;
  P4.Z := D.Center.Y;

  { SchnittGG is using XZ }
  SchnittGG(P1, P2, P3, P4, SP);

  S.Center.X := SP.X;
  S.Center.Y := SP.Z;
end;

constructor TRggDrawingZ15.Create;
var
  L: TRggLine;
begin
  inherited;
  Name := 'Z15-SchnittGG';

  { Help Text }

  HT := TRggLabel.Create;
  HT.Caption := 'HelpText';
  HT.Text := GetHelpText;
  HT.StrokeColor := TRggColors.Tomato;
  HT.IsMemoLabel := True;
  Add(HT);

  { Points }

  A := TRggCircle.Create('A');
  A.StrokeColor := TRggColors.Yellow;

  B := TRggCircle.Create('B');
  B.StrokeColor := TRggColors.Red;

  C := TRggCircle.Create('C');
  C.StrokeColor := TRggColors.Green;

  D := TRggCircle.Create('D');
  D.StrokeColor := TRggColors.Blue;

  S := TRggCircle.Create('S');
  S.StrokeColor := TRggColors.Coral;
  S.IsComputed := True;

  InitDefaultPos;

  { Lines }

  DefaultShowCaption := False;

  L := TRggLine.Create('AB');
  L.StrokeColor := TRggColors.Dodgerblue;
  L.Point1 := A;
  L.Point2 := B;
  Add(L);

  L := TRggLine.Create('CD');
  L.StrokeColor := TRggColors.Aquamarine;
  L.Point1 := C;
  L.Point2 := D;
  Add(L);

  Add(A);
  Add(B);
  Add(C);
  Add(D);
  Add(S);

  FixPoint3D := A.Center.C;
  WantRotation := False;
  WantSort := False;
  DefaultElement := D;
end;

function TRggDrawingZ15.GetHelpText: string;
begin
  ML.Add('SchnittGG = Schnitt Gerade Gerade = Intersection Line Line.');
  ML.Add('  2D drawing with 2 lines AB and CD.');
  ML.Add('');
  ML.Add('Points A, B, C and D are instances of the TRggCircle class.');
  ML.Add('  TRggLine instances reference two TRggCircle instances.');
  ML.Add('    Line AB references Circle A and Circle B.');
  ML.Add('');
  ML.Add('Schnittpunkt SP is computed with SchnittGG(P1, P2, P3, P4, SP);');
  ML.Add('  with P1.X := A.Center.X; and so on see code at GitHub.');
  ML.Add('');
  ML.Add('Intersection point S is a computed point (Circle S).');
  ML.Add('  Computed circle elements (--) cannot be selected/dragged.');

  result := ML.Text;
  ML.Clear;
end;

function TRggDrawingZ15.SchnittGG(P1, P2, P3, P4: TPoint3D; out SP: TPoint3D): Boolean;
var
  a1, a2: single;
  sx, sz, x1, z1, x3, z3: single;
  Quotient: single;
  Fall: TBemerkungGG;
begin
  result := True;
  Fall := ggOK;

  a1 := 0;
  a2 := 0;
  sx := 0;
  sz := 0;

  x1 := P1.X;
  z1 := P1.Z;
  x3 := P3.X;
  z3 := P3.Z;

  Quotient := P2.X - P1.X;
  if abs(Quotient) > 0.001 then
    a1 := (P2.Z - P1.Z) / Quotient
  else
    Fall := g1Vertical;

  Quotient := P4.X - P3.X;
  if abs(Quotient) > 0.001 then
    a2 := (P4.Z - P3.Z) / Quotient
  else
    Fall := g2Vertical;

  if (Fall = ggOK) and (abs(a2-a1) < 0.001) then
    Fall := ggParallel;

  case Fall of
    ggParallel:
    begin
      sx := 0;
      sz := 0;
      result := False;
    end;

    ggOK:
      begin
        sx := (-a1 * x1 + a2 * x3 - z3 + z1) / (-a1 + a2);
        sz := (-a2 * a1 * x1 + a2 * z1 + a2 * x3 * a1 - z3 * a1) / (-a1 + a2);
      end;

    g1Vertical:
      begin
        sz := a2 * x1 - a2 * x3 + z3;
        sx := x1;
      end;

    g2Vertical:
      begin
        sz := a1 * x3 - a1 * x1 + z1;
        sx := x3;
      end;
  end;

  SP.X := sx;
  SP.Y := 0;
  SP.Z := sz;
end;

end.
