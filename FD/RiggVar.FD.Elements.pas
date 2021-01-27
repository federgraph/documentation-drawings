unit RiggVar.FD.Elements;

(*
-
-     F
-    * * *
-   *   *   G
-  *     * *   *
- E - - - H - - - I
-  *     * *         *
-   *   *   *           *
-    * *     *             *
-     D-------A---------------B
-              *
-              (C) federgraph.de
-
*)

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  System.UIConsts,
  System.Math,
  System.Math.Vectors,
  System.Generics.Collections,
  System.Generics.Defaults,
  FMX.Types,
  FMX.Objects,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Graphics;

type
  TRggPoint3D = record
    function Rotate(const AAngle: Single): TRggPoint3D;
    function Angle(const APoint: TRggPoint3D): single;
    function Length: single;
    function Normalize: TRggPoint3D;
    function Distance(const APoint: TRggPoint3D): single;
    class function Zero: TRggPoint3D; static;

    class operator Add(const APoint1, APoint2: TRggPoint3D): TRggPoint3D;
    class operator Subtract(const APoint1, APoint2: TRggPoint3D): TRggPoint3D;

    case Integer of
      0: (X: single;
          Y: single;
          Z: single;);
      1: (C: TPoint3D);
      2: (P: TPointF;
          T: single;);
      3: (V: TVectorArray;);
  end;

  TRggPoly = array of TRggPoint3D;

  TBemerkungGG = (
    g1Vertical,
    g2Vertical,
    ggParallel,
    ggOK
  );

  TBemerkungKK = (
    bmKonzentrisch,
    bmZwei,
    bmEinerAussen,
    bmEntfernt,
    bmEinerK1inK2,
    bmEinerK2inK1,
    bmK1inK2,
    bmK2inK1,
    bmRadiusFalsch
  );

  TSchnittEbene = (seXY, seYZ, seXZ);

  TSchnittKK = class
  private
    R1: single;
    R2: single;
    FM1: TPoint3D;
    FM2: TPoint3D;
    S1: TPoint3D;
    S2: TPoint3D;
    Ebene: TSchnittEbene;
    Bem: TBemerkungKK;
    NeedCalc: Boolean;
    sv: Boolean;
    procedure SetRadius1(Value: single);
    procedure SetRadius2(Value: single);
    procedure SetMittelPunkt1(Value: TPoint3D);
    procedure SetMittelPunkt2(Value: TPoint3D);
    function GetSchnittPunkt1: TPoint3D;
    function GetSchnittPunkt2: TPoint3D;
    function GetBem: TBemerkungKK;
    function GetBemerkung: string;
    function GetRemark: string;
    function Vorhanden: Boolean;
    procedure SetM1(const Value: TPointF);
    procedure SetM2(const Value: TPointF);
  protected
    procedure Schnitt; virtual;
  public
    Watch1: Integer;
    Watch2: Integer;

    function AngleXZM(P1, P2: TPoint3D): single;
    function AngleXZ(P1, P2: TPoint3D): single;
    function AngleZXM(P1, P2: TPoint3D): single;
    function AngleZX(P1, P2: TPoint3D): single;
    function AnglePointXZ(P: TPoint3D; R: single; AngleInRad: single): TPoint3D;
    function IntersectionXZ1(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
    function IntersectionXZ2(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
    function IntersectionXZ(ASelector: Integer; AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;

    property Radius1: single read R1 write SetRadius1;
    property Radius2: single read R2 write SetRadius2;
    property M1: TPointF write SetM1;
    property M2: TPointF write SetM2;
    property MittelPunkt1: TPoint3D read FM1 write SetMittelPunkt1;
    property MittelPunkt2: TPoint3D read FM2 write SetMittelPunkt2;
    property SchnittPunkt1: TPoint3D read GetSchnittPunkt1;
    property SchnittPunkt2: TPoint3D read GetSchnittPunkt2;
    property Status: TBemerkungKK read GetBem;
    property Remark: string read GetRemark;
    property Bemerkung: string read GetBemerkung;
    property SPVorhanden: Boolean read Vorhanden;
    property SchnittEbene: TSchnittEbene read Ebene write Ebene;
  end;

  TRggSchnittKK = class(TSchnittKK)
  private
  public
    function AngleM(P1, P2: TPoint3D): single;
    function Angle(P1, P2: TPoint3D): single;
    function OuterAngle(P1, P2: TPoint3D): single;

    function AnglePoint(P: TRggPoint3D; R: single; AngleInRad: single): TPoint3D; overload;
    function AnglePoint(P: TPoint3D; R: single; AngleInRad: single): TPoint3D; overload;

    function Intersection1(AM1, AM2: TRggPoint3D; AR1, AR2: single): TPoint3D; overload;
    function Intersection2(AM1, AM2: TRggPoint3D; AR1, AR2: single): TPoint3D; overload;

    function Intersection1(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D; overload;
    function Intersection2(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D; overload;

    function Intersection(ASelector: Integer; AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D; overload;
  end;

  TRggColor = TAlphaColor;

  TRggColors = class
  public
    class var
    Alpha: TRggColor;
    Aliceblue: TRggColor;
    Antiquewhite: TRggColor;
    Aqua: TRggColor;
    Aquamarine: TRggColor;
    Azure: TRggColor;
    Beige: TRggColor;
    Bisque: TRggColor;
    Black: TRggColor;
    Blanchedalmond: TRggColor;
    Blue: TRggColor;
    Blueviolet: TRggColor;
    Brown: TRggColor;
    Burlywood: TRggColor;
    Cadetblue: TRggColor;
    Chartreuse: TRggColor;
    Chocolate: TRggColor;
    Coral: TRggColor;
    Cornflowerblue: TRggColor;
    Cornsilk: TRggColor;
    Crimson: TRggColor;
    Cyan: TRggColor;
    Darkblue: TRggColor;
    Darkcyan: TRggColor;
    Darkgoldenrod: TRggColor;
    Darkgray: TRggColor;
    Darkgreen: TRggColor;
    Darkgrey: TRggColor;
    Darkkhaki: TRggColor;
    Darkmagenta: TRggColor;
    Darkolivegreen: TRggColor;
    Darkorange: TRggColor;
    Darkorchid: TRggColor;
    Darkred: TRggColor;
    Darksalmon: TRggColor;
    Darkseagreen: TRggColor;
    Darkslateblue: TRggColor;
    Darkslategray: TRggColor;
    Darkslategrey: TRggColor;
    Darkturquoise: TRggColor;
    Darkviolet: TRggColor;
    Deeppink: TRggColor;
    Deepskyblue: TRggColor;
    Dimgray: TRggColor;
    Dimgrey: TRggColor;
    Dodgerblue: TRggColor;
    Firebrick: TRggColor;
    Floralwhite: TRggColor;
    Forestgreen: TRggColor;
    Fuchsia: TRggColor;
    Gainsboro: TRggColor;
    Ghostwhite: TRggColor;
    Gold: TRggColor;
    Goldenrod: TRggColor;
    Gray: TRggColor;
    Green: TRggColor;
    Greenyellow: TRggColor;
    Grey: TRggColor;
    Honeydew: TRggColor;
    Hotpink: TRggColor;
    Indianred: TRggColor;
    Indigo: TRggColor;
    Ivory: TRggColor;
    Khaki: TRggColor;
    Lavender: TRggColor;
    Lavenderblush: TRggColor;
    Lawngreen: TRggColor;
    Lemonchiffon: TRggColor;
    Lightblue: TRggColor;
    Lightcoral: TRggColor;
    Lightcyan: TRggColor;
    Lightgoldenrodyellow: TRggColor;
    Lightgray: TRggColor;
    Lightgreen: TRggColor;
    Lightgrey: TRggColor;
    Lightpink: TRggColor;
    Lightsalmon: TRggColor;
    Lightseagreen: TRggColor;
    Lightskyblue: TRggColor;
    Lightslategray: TRggColor;
    Lightslategrey: TRggColor;
    Lightsteelblue: TRggColor;
    Lightyellow: TRggColor;
    LtGray: TRggColor;
    MedGray: TRggColor;
    DkGray: TRggColor;
    MoneyGreen: TRggColor;
    LegacySkyBlue: TRggColor;
    Cream: TRggColor;
    Lime: TRggColor;
    Limegreen: TRggColor;
    Linen: TRggColor;
    Magenta: TRggColor;
    Maroon: TRggColor;
    Mediumaquamarine: TRggColor;
    Mediumblue: TRggColor;
    Mediumorchid: TRggColor;
    Mediumpurple: TRggColor;
    Mediumseagreen: TRggColor;
    Mediumslateblue: TRggColor;
    Mediumspringgreen: TRggColor;
    Mediumturquoise: TRggColor;
    Mediumvioletred: TRggColor;
    Midnightblue: TRggColor;
    Mintcream: TRggColor;
    Mistyrose: TRggColor;
    Moccasin: TRggColor;
    Navajowhite: TRggColor;
    Navy: TRggColor;
    Oldlace: TRggColor;
    Olive: TRggColor;
    Olivedrab: TRggColor;
    Orange: TRggColor;
    Orangered: TRggColor;
    Orchid: TRggColor;
    Palegoldenrod: TRggColor;
    Palegreen: TRggColor;
    Paleturquoise: TRggColor;
    Palevioletred: TRggColor;
    Papayawhip: TRggColor;
    Peachpuff: TRggColor;
    Peru: TRggColor;
    Pink: TRggColor;
    Plum: TRggColor;
    Powderblue: TRggColor;
    Purple: TRggColor;
    Red: TRggColor;
    Rosybrown: TRggColor;
    Royalblue: TRggColor;
    Saddlebrown: TRggColor;
    Salmon: TRggColor;
    Sandybrown: TRggColor;
    Seagreen: TRggColor;
    Seashell: TRggColor;
    Sienna: TRggColor;
    Silver: TRggColor;
    Skyblue: TRggColor;
    Slateblue: TRggColor;
    Slategray: TRggColor;
    Slategrey: TRggColor;
    Snow: TRggColor;
    Springgreen: TRggColor;
    Steelblue: TRggColor;
    Tan: TRggColor;
    Teal: TRggColor;
    Thistle: TRggColor;
    Tomato: TRggColor;
    Turquoise: TRggColor;
    Violet: TRggColor;
    Wheat: TRggColor;
    White: TRggColor;
    Whitesmoke: TRggColor;
    Yellow: TRggColor;
    Yellowgreen: TRggColor;

    WindowWhite: TRggColor;
    ColorF9F9F9: TRggColor;
    Color372E69: TRggColor;
    Color333333: TRggColor;

    Null: TRggColor;

  public
    class constructor Create;
    class function ColorFromRGB(R, G, B: Byte): TRggColor;
  end;

  TRggColorScheme = record
    TextColor: TAlphaColor;
    BackgroundColor: TAlphaColor;
    LabelColor: TAlphaColor;
    procedure GoDark;
    procedure GoLight;
  end;

  TLineSegmentCompareCase = (
    ccNone,
    ccNil,
    ccHardcodedAbove,
    ccHardcodedBelow,
    ccParallel,
    ccTotallyAbove,
    ccTotallyBelow,
    ccTotallySame,
    ccCommonNone,
    ccCommonAbove,
    ccCommonBelow,
    ccCommonSame,
    ccAbove,
    ccBelow,
    ccSame,
    ccUnknown
  );

  TRggDrawingBase = class
  private
    FIsDark: Boolean;
    procedure SetIsDark(const Value: Boolean);
    function GetDefaultShowCaption: Boolean;
    procedure SetDefaultShowCaption(const Value: Boolean);
  public
    WantRotation: Boolean;
    WheelFlag: Boolean;
    InplaceFlag: Boolean;
    ViewpointFlag: Boolean;
    FixPoint3D: TPoint3D;
    Colors: TRggColorScheme;
    FaxPoint3D: TRggPoint3D;
    class var
      WantOffset: Boolean;
    procedure Reset; virtual; abstract;
    procedure Transform(M: TMatrix3D); virtual; abstract;
    procedure GoDark; virtual;
    procedure GoLight; virtual;
    property IsDark: Boolean read FIsDark write SetIsDark;
    property DefaultShowCaption: Boolean read GetDefaultShowCaption write SetDefaultShowCaption;
  end;

  TRotationHelper = class
  public
    function IsEssentiallyZero(const Value: Single): Boolean;

    function RotD(Value: TPoint3D): TPoint3D;
    function RotR(Value: TPoint3D): TPoint3D;

    function EulerAnglesFromMatrix(m: TMatrix3D): TPoint3D;
    function EulerAnglesToMatrix(heading, attitude, bank: single): TMatrix3D;

    function EulerAnglesFromQuaternion(q: TQuaternion3D): TPoint3D;
    function EulerAnglesToQuaternion(yaw, pitch, roll: single): TQuaternion3D;

    function GetRotationInfoHPB(rm: TMatrix3D): TPoint3D;
  end;

  TTransformHelper = class
  private
    FOnDrawToCanvas: TNotifyEvent;
    FOnShowRotation: TNotifyEvent;
    procedure SetOnDrawToCanvas(const Value: TNotifyEvent);
    procedure SetOnShowRotation(const Value: TNotifyEvent);
  public
    NewMatrix: TMatrix3D;
    AccuMatrix: TMatrix3D;

    RotationHelper: TRotationHelper;

    DirX: TPoint3D;
    DirY: TPoint3D;
    DirZ: TPoint3D;

    Offset: TPoint3D;
    Rotation: TPoint3D;
    ZoomDelta: single;

    CurrentDrawing: TRggDrawingBase;

    RotD: TPoint3D;
    RotR: TPoint3D;
    RotB: Boolean;

    IsRightMouseBtn: Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure DoOnMouse(Shift: TShiftState; dx, dy: single);

    procedure BuildMatrix(mr: TMatrix3D);
    procedure BuildMatrixM;
    procedure ResetTransform;
    procedure InitTransform(mr: TMatrix3D);
    procedure UpdateTransform;
    function BuildMatrixG(NewFixPoint3D: TPoint3D): TMatrix3D;
    function BuildMatrixF: TMatrix3D;
    function BuildMatrixI: TMatrix3D;

    procedure GetEulerAngles; virtual;

    procedure Reset;
    procedure Draw;
    procedure DrawToCanvas;
    procedure ShowRotation(r: TPoint3D; b: Boolean);

    property OnDrawToCanvas: TNotifyEvent read FOnDrawToCanvas write SetOnDrawToCanvas;
    property OnShowRotation: TNotifyEvent read FOnShowRotation write SetOnShowRotation;
  end;

  TRggElement = class
  private
    FStrokeColor: TAlphaColor;
    FStrokeThickness: single;
    FStrokeDash: TStrokeDash;
    FOpacity: single;
    procedure SetStrokeColor(const Value: TAlphaColor);
    procedure SetStrokeThickness(const Value: single);
    procedure SetStrokeDash(const Value: TStrokeDash);
    procedure SetOpacity(const Value: single);
  protected
    TypeName: string;
    TextCenter: TPointF;
    TextAngle: single;
    TextRadius: single;
    WantTextRect: Boolean;
    class var
    Temp1: TRggPoint3D;
    Temp2: TRggPoint3D;
    Temp3: TRggPoint3D;
    procedure TextOut(g: TCanvas; s: string);
    procedure TextOutLeading(g: TCanvas; s: string);
  public
    Caption: string;
    ShowCaption: Boolean;
    SpecialDraw: Boolean;
    Painted: Boolean;
    IsComputed: Boolean;
    IndentItem: Boolean;
    Visible: Boolean;
    Drawing: TRggDrawingBase;

    const
      Eps = 0.0001;
      DefaultTextAngle: single = 45 * Pi / 180;
      DefaultTextRadius: single = 30.0;

    class var
      GlobalShowCaption: Boolean;
      DefaultShowCaption: Boolean;

    constructor Create;

    function GetListCaption: string; virtual;
    procedure GetInfo(ML: TStrings); virtual;
    function GetValid: Boolean; virtual;

    procedure Transform; virtual;
    procedure Draw(g: TCanvas); virtual;

    procedure Param1(Delta: single); virtual;
    procedure Param2(Delta: single); virtual;
    procedure Param3(Delta: single); virtual;

    procedure Param7(Delta: single);
    procedure Param8(Delta: single);

    property Opacity: single read FOpacity write SetOpacity;
    property StrokeThickness: single read FStrokeThickness write SetStrokeThickness;
    property StrokeColor: TAlphaColor read FStrokeColor write SetStrokeColor;
    property StrokeDash: TStrokeDash read FStrokeDash write SetStrokeDash;
  end;

  TRggLabel = class(TRggElement)
  public
    Position: TPointF;
    Text: string;
    IsMemoLabel: Boolean;
    constructor Create;
    function GetListCaption: string; override;
    procedure Draw(g: TCanvas); override;
  end;

  TRggParam = class(TRggElement)
  private
    FOriginalValue: single;
    FValue: single;
    FScale: single;
    FBaseValue: single;
    procedure SetValue(const Value: single);
    function GetRelativeValue: single;
    procedure SetScale(const Value: single);
    procedure SetBaseValue(const Value: single);
  public
    StartPoint: TPointF;
    Text: string;
    constructor Create;
    procedure Save;
    procedure Reset;
    procedure Param1(Delta: single); override;
    procedure Draw(g: TCanvas); override;
    property Value: single read FValue write SetValue;
    property BaseValue: single read FBaseValue write SetBaseValue;
    property OriginalValue: single read FOriginalValue;
    property RelativeValue: single read GetRelativeValue;
    property Scale: single read FScale write SetScale;
  end;

  TRggCircle = class(TRggElement)
  private
    FRadius: single;
    procedure SetRadius(const Value: single);
  protected
    property Radius: single read FRadius write SetRadius;
  public
    OriginalCenter: TRggPoint3D;
    Center: TRggPoint3D;
    class var
      Matrix: TMatrix3D;

    constructor Create; overload;
    constructor Create(ACaption: string); overload;

    procedure Save;
    procedure Reset;
    procedure Transform; override;
    procedure TransformI;
    procedure WriteCode(ML: TStrings);

    procedure Draw(g: TCanvas); override;

    procedure Param1(Delta: single); override;
    procedure Param2(Delta: single); override;
    procedure Param3(Delta: single); override;

    procedure Param1I(Delta: single);
    procedure Param2I(Delta: single);

    function IsEqual(B: TRggCircle): Boolean;
    function CompareZ(Q: TRggCircle): Integer;

    class function Compare(const Left, Right: TRggCircle): Integer;
  end;

  TRggBigCircle = class(TRggCircle)
  public
    constructor Create(ACaption: string = '');
    procedure Draw(g: TCanvas); override;
    procedure Param3(Delta: single); override;
    property Radius;
  end;

  TRggFixpointCircle = class(TRggCircle)
  public
    constructor Create(ACaption: string = '');
    procedure Draw(g: TCanvas); override;
  end;

  TRggBigArc = class(TRggElement)
  private
    FSweepAngle: single;
    procedure SetSweepAngle(const Value: single);
  public
    Point1: TRggCircle;
    Point2: TRggCircle;

    constructor Create(ACaption: string = '');

    procedure GetInfo(ML: TStrings); override;
    function GetValid: Boolean; override;

    procedure Draw(g: TCanvas); override;

    procedure Param1(Delta: single); override;

    property SweepAngle: single read FSweepAngle write SetSweepAngle;
  end;

  TRggLine = class(TRggElement)
  private
    function GetLength: single;
  public
    Point1: TRggCircle;
    Point2: TRggCircle;

    Bemerkung: TLineSegmentCompareCase;

    constructor Create(ACaption: string = '');

    procedure GetInfo(ML: TStrings); override;
    function GetValid: Boolean; override;

    procedure Draw(g: TCanvas); override;
    procedure Param1(Delta: single); override;
    procedure Param2(Delta: single); override;
    function V2: TPointF;
    function V3: TPoint3D;

    function IsSame(Other: TRggLine): Boolean;
    function IsTotallyAbove(Other: TRggLine): Boolean;
    function IsTotallyBelow(Other: TRggLine): Boolean;
    function ComputeSPZ(SP: TPoint3D): single;
    procedure ReportData(ML: TStrings);

    class var
    CounterLeftNil: Integer;
    CounterRightNil: Integer;
    CounterHardCodedAbove: Integer;
    CounterHardCodedBelow: Integer;
    CounterSame: Integer;
    CounterTotallyAbove: Integer;
    CounterTotallyBelow: Integer;
    CounterCommon: Integer;
    CounterParallel: Integer;
    CounterSPZ: Integer;
    CounterZero: Integer;

    class procedure ResetCounter;
    class function CounterSum: Integer;
    class function Compare(const Left, Right: TRggLine): Integer;

    property LineLength: single read GetLength;
  end;

  TRggRotaLine = class(TRggLine)
  public
    constructor Create(ACaption: string = '');
    procedure Param1(Delta: single); override;
    procedure Param2(Delta: single); override;
  end;

  TRggLagerLine = class(TRggLine)
  private
    procedure DrawLager(g: TCanvas; P: TPointF; FestLager: Boolean);
  public
    procedure Draw(g: TCanvas); override;
  end;

  TRggPolyLine = class(TRggLine)
  private
    FCount: Integer;
  protected
    TransformedPoly: TPolygon;
    PD: TPathData;
    procedure DrawPoly(g: TCanvas; p: TPolygon);
    procedure DrawText(g: TCanvas);
  public
    Poly: TPolygon;
    ShowPoly: Boolean;
    constructor Create(ACaption: string = ''); overload;
    constructor Create(ACaption: string; ACount: Integer); overload;
    destructor Destroy; override;
    procedure Draw(g: TCanvas); override;
    property Count: Integer read FCount;
  end;

  TRggPolyCurve = class(TRggElement)
  private
    FCount: Integer;
  protected
    PD: TPathData;
    TransformedPoly: TPolygon;
    procedure DrawPoly(g: TCanvas; p: TPolygon);
    procedure DrawText(g: TCanvas);
  public
    Poly: TPolygon;
    constructor Create(ACaption: string; ACount: Integer); overload;
    destructor Destroy; override;
    procedure AssignPoly(const APoly: TPolygon);
    procedure Draw(g: TCanvas); override;
    property Count: Integer read FCount;
  end;

  TRggPolyLine3D = class(TRggPolyLine)
  private
    procedure UpdateCount;
  public
    RggPoly: TRggPoly;
    WantRotation: Boolean;
    constructor Create(ACaption: string; ACount: Integer);
    procedure Transform; override;
    procedure Draw(g: TCanvas); override;
    procedure Reset;
  end;

  TRggFederLine = class(TRggPolyLine)
  private
    function RotateDegrees(ov: TPoint3D; wi: single): TPoint3D;
  public
    constructor Create(ACaption: string = '');
    procedure Draw(g: TCanvas); override;
  end;

  TRggTriangle = class(TRggElement)
  private
    Poly: TPolygon;
  public
    Point1: TRggCircle;
    Point2: TRggCircle;
    Point3: TRggCircle;
    constructor Create;
    procedure GetInfo(ML: TStrings); override;
    function GetValid: Boolean; override;
    procedure Draw(g: TCanvas); override;
  end;

  TRggArc = class(TRggElement)
  private
    FTextRadiusFactor: single;
    FRadius: single;
    RadiusF: TPointF;
    procedure SetRadius(const Value: single);
    function GetSweepAngle: single;
  public
    Point1: TRggCircle; // injected
    Point2: TRggCircle;
    Point3: TRggCircle;
    constructor Create(ACaption: string);
    procedure GetInfo(ML: TStrings); override;
    function GetValid: Boolean; override;
    procedure Param1(Delta: single); override;
    procedure Param2(Delta: single); override;
    procedure Draw(g: TCanvas); override;
    property Radius: single read FRadius write SetRadius;
    property SweepAngle: single read GetSweepAngle;
  end;

  TRggLinePair = record
    L1: TRggLine;
    L2: TRggLine;
    SP: TPoint3D;
    function SchnittGG: Boolean;
    function HasCommonPoint: Boolean;
    function CompareCommon: Integer;
    function IsParallel: Boolean;
    function CompareSPZ: Integer;
    procedure ReportData(ML: TStrings);
    function CompareVV(v1, v2: TPoint3D): Integer;
  end;

  TSchnittKKCircleLL = class(TRggCircle)
  public
    Radius1: single;
    Radius2: single;
    L1: TRggLine;
    L2: TRggLine;
    SchnittKK: TSchnittKK;
    Counter: Integer;
    constructor Create(ACaption: string = '');
    destructor Destroy; override;
    procedure GetInfo(ML: TStrings); override;
    function GetValid: Boolean; override;
    procedure Param1(Delta: single); override;
    procedure Param2(Delta: single); override;
    procedure Compute;
    procedure InitRadius;
  end;

  TSchnittKKCircle = class(TRggCircle)
  private
    R1: single;
    R2: single;
    S1: TPoint3D;
    S2: TPoint3D;
    sv: Boolean;
    NeedCalc: Boolean;
    Bem: TBemerkungKK;
    procedure ComputeInternal;
    function GetBem: TBemerkungKK;
    function GetBemerkung: string;
    function Vorhanden: Boolean;
    function GetL1: single;
    function GetL2: single;
  public
    Radius1: single;
    Radius2: single;
    MP1: TRggCircle;
    MP2: TRggCircle;
    Counter: Integer;
    WantS2: Boolean;
    constructor Create(ACaption: string = '');
    procedure GetInfo(ML: TStrings); override;
    function GetValid: Boolean; override;
    procedure Param1(Delta: single); override;
    procedure Param2(Delta: single); override;
    procedure Compute;
    procedure InitRadius;
    procedure Draw(g: TCanvas); override;
    property Status: TBemerkungKK read GetBem;
    property Bemerkung: string read GetBemerkung;
    property SPVorhanden: Boolean read Vorhanden;
    property L1: single read GetL1;
    property L2: single read GetL2;
  end;

  TRggBox = record
  public
    X: Integer;
    Y: Integer;
    Width: Integer;
    Height: Integer;
  end;

  TRggChart = class(TRggElement)
  protected
    PD: TPathData;
    LNr: Integer;
    procedure DrawText(g: TCanvas);
    procedure DrawPoly1(g: TCanvas);
    procedure DrawPoly2(g: TCanvas);
  public
    Poly: array of single;

    Box: TRggBox;

    Xmin: single;
    Xmax: single;
    Ymin: single;
    Ymax: single;

    ChartPunktX: single;

    WantChartPunktX: Boolean;
    WantRectangles: Boolean;
    WantCurve: Boolean;

    PointRadius: single;
    CurveOpacity: single;

    constructor Create(ACount: Integer = 20);
    destructor Destroy; override;
    procedure Draw(g: TCanvas); override;

    procedure InitDefault;

    procedure LookForYMinMax;
    property Count: Integer read LNr;
  end;

  TRggButtonGroup = class
  public
    Btn1: TSpeedButton;
    Btn2: TSpeedButton;
    Btn3: TSpeedButton;
    Btn4: TSpeedButton;
    Btn5: TSpeedButton;
    Btn6: TSpeedButton;
    Btn7: TSpeedButton;
    Btn8: TSpeedButton;
    Btn9: TSpeedButton;
    Btn0: TSpeedButton;

    BtnA: TSpeedButton;
    BtnB: TSpeedButton;
    BtnC: TSpeedButton;
    BtnD: TSpeedButton;
    BtnE: TSpeedButton;
    BtnF: TSpeedButton;

    procedure Reset;

    class var OnUpdateDrawing: TNotifyEvent;
    class procedure UpdateDrawing;
  end;

  TRggElementList = TList<TRggElement>;
  TRggCircleList = TList<TRggCircle>;
  TRggLineList = TList<TRggLine>;

  TRggCircleComparer = class(TInterfacedObject, IComparer<TRggCircle>)
  public
    function Compare(const Left, Right: TRggCircle): Integer;
  end;

  TRggLineComparer = class(TInterfacedObject, IComparer<TRggLine>)
  public
    function Compare(const Left, Right: TRggLine): Integer;
  end;

  TRggDrawing = class(TRggDrawingBase)
  private
    FName: string;
    FWantSort: Boolean;
    ElementList: TRggElementList;
    function GetElement(Index: Integer): TRggElement;
    procedure SetName(const Value: string);
    procedure SortedDraw(g: TCanvas);
    procedure UnsortedDraw(g: TCanvas);
    function GetIsValid: Boolean;
    function GetDefaultElementIndex: Integer;
    procedure SetWantSort(const Value: Boolean);
  protected
    CircleComparer: IComparer<TRggCircle>;
    LineComparer: IComparer<TRggLine>;
    SortedCircleList: TRggCircleList;
    SortedLineList: TRggLineList;
    function Find(ACaption: string): TRggCircle;
  public
    CircleList: TRggCircleList;
    LineList: TRggLineList;

    DefaultElement: TRggElement;

    ML: TStrings;
    WantMemoLines: Boolean;

    class var TH: TTransformHelper;

    constructor Create;
    destructor Destroy; override;

    procedure Add(Value: TRggElement);

    procedure SortElements;

    procedure InitItems(ML: TStrings);
    procedure WriteCode(ML: TStrings);
    procedure Reset; override;
    procedure Transform(M: TMatrix3D); override;
    procedure InitDefaultPos; virtual;
    procedure SaveAll;
    procedure Compute; virtual;
    procedure InitButtons(BG: TRggButtonGroup); virtual;

    procedure Draw(g: TCanvas);
    procedure GetInfo(ML: TStrings);

    procedure UpdateDrawing;

    property Name: string read FName write SetName;
    property Element[Index: Integer]: TRggElement read GetElement;
    property IsValid: Boolean read GetIsValid;
    property DefaultElementIndex: Integer read GetDefaultElementIndex;
    property MemoLines: TStrings read ML;
    property WantSort: Boolean read FWantSort write SetWantSort;
  end;

  TRggDrawingList = TList<TRggDrawing>;

  TRggDrawings = class
  public
    UseDarkColorScheme: Boolean;
    DrawingList: TRggDrawingList;
    constructor Create;
    destructor Destroy; override;
    procedure Add(Value: TRggDrawing);
    procedure InitItems(ML: TStrings);
  end;

  TRggDrawingKK = class(TRggDrawing)
  protected
    SKK: TRggSchnittKK;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TBitmapDict = TDictionary<single, TBitmap>;

  TBitmapCollection = class
  private
    FNominalSize: TSize;
    FBitmaps: TBitmapDict;
  public
    constructor Create(ANominalSize: TSize);
    destructor Destroy; override;
    function ItemByScale(AScale: single): TBitmap;
    function Add(AScale: single): TBitmap;
  end;

  { This control does not even have a WrapMode property. }
  { But it behaves similar to a TImage with WrapMode set to Original }
  TOriginalImage = class(TControl)
  private
    FCurrentBitmap: TBitmap;
    FNominalSize: TSize;
    BitmapCollection: TBitmapCollection;
    FSS: Single;
    FOnScreenScaleChanged: TNotifyEvent;
    ScreenScaleHasChanged: Boolean;
    function GetBitmap: TBitmap;
    function ItemForCurrentScale: TBitmap;
    procedure SetOnScreenScaleChanged(const Value: TNotifyEvent);
    procedure NotifyScreenScaleChanged;
  protected
    procedure Paint; override;
  public
    IR: TRectF;
    R1: TRectF;
    R2: TRectF;
    { Use reintroduce when you want to hide an inherited virtual method with a new one. }
    constructor Create(AOwner: TComponent; AWidth: Integer; AHeight: Integer); reintroduce;
    destructor Destroy; override;
    property Bitmap: TBitmap read GetBitmap;
  public
    property Scale;
    property ScreenScale: single read FSS;
    property OnScreenScaleChanged: TNotifyEvent read FOnScreenScaleChanged write SetOnScreenScaleChanged;
  end;

implementation

{ TRotationHelper }

function TRotationHelper.IsEssentiallyZero(const Value: Single): Boolean;
begin
  Result := ((Value < Epsilon2) and (Value > -Epsilon2));
end;

function TRotationHelper.RotD(Value: TPoint3D): TPoint3D;
begin
  result := TPoint3D.Create(
    RadToDeg(Value.X),
    RadToDeg(Value.Y),
    RadToDeg(Value.Z));
end;

function TRotationHelper.RotR(Value: TPoint3D): TPoint3D;
begin
  result := TPoint3D.Create(
    DegToRad(Value.X),
    DegToRad(Value.Y),
    DegToRad(Value.Z));
end;

function TRotationHelper.EulerAnglesFromQuaternion(q: TQuaternion3D): TPoint3D;
var
  test: single;
  sqx: single;
  sqy: single;
  sqz: single;
  heading: single;
  attitude: single;
  bank: single;
begin
  test := q.ImagPart.X * q.ImagPart.Y + q.ImagPart.Z * q.RealPart;
  if (test > 0.499) then
  begin
    { singularity at north pole }
    heading := 2 * arctan2(q.ImagPart.X, q.RealPart);
    attitude := Pi / 2;
    bank := 0;
  end
  else if (test < -0.499) then
  begin
    { singularity at south pole }
    heading := -2 * arctan2(q.ImagPart.X, q.RealPart);
    attitude := - Pi / 2;
    bank := 0;
  end
  else
  begin
    sqx := q.ImagPart.X * q.ImagPart.X;
    sqy := q.ImagPart.Y * q.ImagPart.Y;
    sqz := q.ImagPart.Z * q.ImagPart.Z;

    heading := arctan2(
      2 * q.ImagPart.Y * q.RealPart - 2 * q.ImagPart.X * q.ImagPart.Z,
      1 - 2 * sqy - 2 * sqz);

    attitude := arcsin(2 * test);

    bank := arctan2(
      2 * q.ImagPart.X * q.RealPart - 2 * q.ImagPart.Y * q.ImagPart.Z,
      1 - 2 * sqx - 2 * sqz);
  end;

  result := TPoint3D.Create(heading, attitude, bank);
end;

function TRotationHelper.EulerAnglesToQuaternion(yaw, pitch, roll: single): TQuaternion3D;
var
  cy, sy, cp, sp, cr, sr: single;
  q: TQuaternion3D;
begin
  { Z = yaw,
    Y = pitch,
    X = roll }

  cy := cos(yaw * 0.5);
  sy := sin(yaw * 0.5);

  cp := cos(pitch * 0.5);
  sp := sin(pitch * 0.5);

  cr := cos(roll * 0.5);
  sr := sin(roll * 0.5);

  q.ImagPart.X := sr * cp * cy - cr * sp * sy;
  q.ImagPart.Y := cr * sp * cy + sr * cp * sy;
  q.ImagPart.Z := cr * cp * sy - sr * sp * cy;

  q.RealPart := cr * cp * cy + sr * sp * sy;

  result := q;
end;

function TRotationHelper.EulerAnglesFromMatrix(m: TMatrix3D): TPoint3D;
var
  heading: single;
  attitude: single;
  bank: single;
begin

{  this conversion uses conventions as described on page:
   https://www.euclideanspace.com/maths/geometry/rotations/euler/index.htm

   Coordinate System: right hand
   Positive angle: right hand
   Order of euler angles: heading first, then attitude, then bank

   matrix row column ordering in code on website:
   [m00 m01 m02]
   [m10 m11 m12]
   [m20 m21 m22]

   matrix row column ordering in TMatrix3D:
   [m11 m12 m13]
   [m21 m22 m23]
   [m31 m32 m33]
}

  { Tait-Bryan angles Y1 Z2 X3 }

  { Assuming the angles are in radians. }
  if (m.m21 > 0.998) then
  begin
    { singularity at north pole }
    heading := arctan2(m.m13, m.m33);
    attitude := Pi / 2;
    bank := 0;
  end
  else if (m.m21 < -0.998) then
  begin
    { singularity at south pole }
    heading := arctan2(m.m13, m.m33);
    attitude := -Pi / 2;
    bank := 0;
  end
  else
  begin
    heading := arctan2(-m.m31, m.m11);
    attitude := arcsin(m.m21);
    bank := arctan2(-m.m23, m.m22);
  end;

  result := TPoint3D.Create(heading, attitude, bank);
end;

function TRotationHelper.EulerAnglesToMatrix(heading, attitude, bank: single): TMatrix3D;
var
  c1, s1: single;
  c2, s2: single;
  c3, s3: single;
begin
  result := TMatrix3D.Identity;

  { angles are in radians }
  c1 := cos(heading);
  s1 := sin(heading);

  c2 := cos(attitude);
  s2 := sin(attitude);

  c3 := cos(bank);
  s3 := sin(bank);

  { http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToMatrix/index.htm }
  { https://en.wikipedia.org/wiki/Euler_angles }

  { Tait-Bryan angles Y1 Z2 X3 }

  { first row }
  result.m11 := c1 * c2; { first column }
  result.m12 := s1 * s3 - c1 * s2 * c3;
  result.m13 := c1 * s2 * s3 + s1 * c3;

  { second row }
  result.m21 := s2;
  result.m22 := c2 * c3;
  result.m23 := -c2 * s3;

  { third row }
  result.m31 := -s1 * c2;
  result.m32 := s1 * s2 * c3 + c1 * s3;
  result.m33 := -s1 * s2 * s3 + c1 * c3;
end;

function TRotationHelper.GetRotationInfoHPB(rm: TMatrix3D): TPoint3D;
var
  psi, the, phi: single;
begin
  { intended to match Y1 X2 Z2 = CreateRotationHeadingPitchBank }

{ Y1 X2 Z2

  m11 := c1 c3    + s1 s2 s3
  m12 := c3 s1 s2 - c1 s3
  m13 := c2 s1

  m21 := c2 s3
  m22 := c2 c3
  m23 := -s2

  m31 := -c1 s2 s3 - c3 s1
  m32 :=  c1 c3 s2 + s1 s3
  m33 := c1 c2
}

  the := -ArcSin(rm.m23);
  if IsEssentiallyZero(the) then
  begin
    phi := 0;
    if IsEssentiallyZero(rm.m13 + 1) then
    begin
      the := Pi / 2;
      psi := arctan2(-rm.m12, rm.m11);
    end
    else
    begin
      the := -Pi / 2;
      psi := arctan2(rm.m12, -rm.m11);
    end;
  end
  else
  begin
    psi := arctan2(rm.m21, rm.m22); // c2 s3 / c2 c3 = s3/c3 = tan(psi)
    phi := arctan2(rm.m13, rm.m33); // c2 s1 / c1 c2 = s1/c1 = tan(phi)
  end;

  result.X := phi;
  result.Y := the;
  result.Z := psi;
end;

{ TTransformHelper }

constructor TTransformHelper.Create;
begin
  ZoomDelta := 1;

  DirX := TPoint3D.Create(1, 0, 0);
  DirY := TPoint3D.Create(0, 1, 0);
  DirZ := TPoint3D.Create(0, 0, 1);

  RotationHelper := TRotationHelper.Create;
  ResetTransform;
end;

destructor TTransformHelper.Destroy;
begin
  RotationHelper.Free;
  inherited;
end;

procedure TTransformHelper.Draw;
begin
  if CurrentDrawing.WantRotation then
  begin
    BuildMatrixM;
    UpdateTransform;
  end;

  DrawToCanvas;
end;

procedure TTransformHelper.DrawToCanvas;
begin
  if Assigned(OnDrawToCanvas) then
    FOnDrawToCanvas(self);
end;

procedure TTransformHelper.ShowRotation(r: TPoint3D; b: Boolean);
begin
  RotR := r;
  RotB := b;
  if Assigned(OnShowRotation) then
    FOnShowRotation(self);
end;

function TTransformHelper.BuildMatrixG(NewFixPoint3D: TPoint3D): TMatrix3D;
var
  mx, my, mz: TMatrix3D;
  mr: TMatrix3D;
  ra: TPoint3D;
begin
  if CurrentDrawing.WantRotation then
  begin
    ra := RotationHelper.EulerAnglesFromMatrix(AccuMatrix);

    mx := TMatrix3D.CreateRotationX(ra.X);
    my := TMatrix3D.CreateRotationY(ra.Y);
    mz := TMatrix3D.CreateRotationZ(ra.Z);
    mr := mx * my * mz;

    CurrentDrawing.FixPoint3D := NewFixPoint3D;

    BuildMatrix(mr);
    result := NewMatrix;
    NewMatrix := TMatrix3D.Identity;
  end
  else
  begin
    result := TMatrix3D.Identity;
  end;
end;

function TTransformHelper.BuildMatrixF: TMatrix3D;
var
  mr: TMatrix3D;
  ra: TPoint3D;
begin
  if CurrentDrawing.WantRotation then
  begin
    ra := RotationHelper.EulerAnglesFromMatrix(AccuMatrix);
    mr := RotationHelper.EulerAnglesToMatrix(ra.X, ra.Y, ra.Z);

    BuildMatrix(mr);
    result := NewMatrix;
    NewMatrix := TMatrix3D.Identity;
  end
  else
  begin
    result := TMatrix3D.Identity;
  end;
end;

function TTransformHelper.BuildMatrixI: TMatrix3D;
var
  mr: TMatrix3D;
  ra: TPoint3D;
begin
  if CurrentDrawing.WantRotation then
  begin
    ra := RotationHelper.EulerAnglesFromMatrix(AccuMatrix);
    mr := RotationHelper.EulerAnglesToMatrix(ra.X, ra.Y, ra.Z);
    mr := mr.Transpose;
    BuildMatrix(mr);
    result := NewMatrix;
    NewMatrix := TMatrix3D.Identity;
  end
  else
  begin
    result := TMatrix3D.Identity;
  end;
end;

procedure TTransformHelper.UpdateTransform;
begin
  AccuMatrix := AccuMatrix * NewMatrix;
  CurrentDrawing.Transform(NewMatrix);
end;

procedure TTransformHelper.InitTransform(mr: TMatrix3D);
begin
  BuildMatrix(mr);
  UpdateTransform;
  DrawToCanvas;
end;

procedure TTransformHelper.ResetTransform;
begin
  TRggCircle.Matrix := TMatrix3D.Identity;
  AccuMatrix := TMatrix3D.Identity;
  Rotation := TPoint3D.Zero;
  Offset := TPoint3D.Zero;
end;

procedure TTransformHelper.Reset;
begin
  ResetTransform;
  CurrentDrawing.Reset;
  Draw;
end;

procedure TTransformHelper.SetOnDrawToCanvas(const Value: TNotifyEvent);
begin
  FOnDrawToCanvas := Value;
end;

procedure TTransformHelper.SetOnShowRotation(const Value: TNotifyEvent);
begin
  FOnShowRotation := Value;
end;

procedure TTransformHelper.BuildMatrixM;
var
  mx, my, mz: TMatrix3D;
  mr: TMatrix3D;
begin
  mx := TMatrix3D.CreateRotationX(Rotation.X);
  my := TMatrix3D.CreateRotationY(Rotation.Y);
  mz := TMatrix3D.CreateRotationZ(Rotation.Z);
  mr := mx * my * mz;

  BuildMatrix(mr);
end;

procedure TTransformHelper.BuildMatrix(mr: TMatrix3D);
var
  mt1, mt2, ms: TMatrix3D;
begin
  mt1 := TMatrix3D.CreateTranslation(-CurrentDrawing.FixPoint3D);
  ms := TMatrix3D.CreateScaling(TPoint3D.Create(ZoomDelta, ZoomDelta, ZoomDelta));
  mt2 := TMatrix3D.CreateTranslation(CurrentDrawing.FixPoint3D);
  NewMatrix := mt1 * mr * ms * mt2;
end;

procedure TTransformHelper.GetEulerAngles;
begin
  RotR := RotationHelper.EulerAnglesFromMatrix(AccuMatrix);
  RotD := RotationHelper.RotD(RotR);
  ShowRotation(RotD, True);
end;

procedure TTransformHelper.DoOnMouse(Shift: TShiftState; dx, dy: single);
begin
  if (ssShift in Shift) or (ssMiddle in Shift) then
  begin
    if dy > 0 then
      ZoomDelta := 1 - 0.01
    else
      ZoomDelta := 1 + 0.01;
  end
  else if ssCtrl in Shift then
  begin
    Offset.X := Offset.X + dx;
    Offset.Y := Offset.Y + dy;
  end

  else
  begin
    if IsRightMouseBtn then
    begin
      Rotation.Z := Rotation.Z + dx * 0.005;
    end
    else
    begin
      Rotation.X := Rotation.X - dy * 0.005;
      Rotation.Y := Rotation.Y + dx * 0.005;
    end;
  end;

  Draw;

  ZoomDelta := 1;
  Rotation := TPoint3D.Zero;
end;

{ TSchnittKK }

procedure TSchnittKK.SetRadius1(Value: single);
begin
  if Value <> R1 then
  begin
    R1 := Value;
    NeedCalc := True;
  end;
end;

procedure TSchnittKK.SetRadius2(Value: single);
begin
  if Value <> R2 then
  begin
    R2 := Value;
    NeedCalc := True;
  end;
end;

procedure TSchnittKK.SetM1(const Value: TPointF);
begin
  FM1.X := Value.X;
  FM1.Y := Value.Y;
  FM1.Z := 0;
  NeedCalc := True;
end;

procedure TSchnittKK.SetM2(const Value: TPointF);
begin
  FM2.X := Value.X;
  FM2.Y := Value.Y;
  FM2.Z := 0;
  NeedCalc := True;
end;

procedure TSchnittKK.SetMittelPunkt1(Value: TPoint3D);
begin
  { if not Value.EqualsTo(FM1) then }
  if (Value.X <> FM1.X) or (Value.Y <> FM1.Y) or (Value.Z <> FM1.Z) then
  begin
    FM1 := Value;
    NeedCalc := True;
  end;
end;

procedure TSchnittKK.SetMittelPunkt2(Value: TPoint3D);
begin
  { if not Value.EqualsTo(FM2) then }
  if (Value.X <> FM2.X) or (Value.Y <> FM2.Y) or (Value.Z <> FM2.Z) then
  begin
    FM2 := Value;
    NeedCalc := True;
  end;
end;

function TSchnittKK.GetSchnittPunkt1: TPoint3D;
begin
  if NeedCalc = True then
    Schnitt;
  result := S1;
end;

function TSchnittKK.GetSchnittPunkt2: TPoint3D;
begin
  if NeedCalc = True then
    Schnitt;
  result := S2;
end;

function TSchnittKK.GetBem: TBemerkungKK;
begin
  if NeedCalc = True then
    Schnitt;
  result := Bem;
end;

function TSchnittKK.Vorhanden: Boolean;
begin
  if NeedCalc = True then
    Schnitt;
  result := sv;
end;

function TSchnittKK.GetBemerkung: string;
begin
  if NeedCalc = True then
    Schnitt;
  case Bem of
    bmKonzentrisch:
      result := 'konzentrische Kreise';
    bmZwei:
      result := 'zwei Schnittpunkte';
    bmEntfernt:
      result := 'zwei entfernte Kreise';
    bmEinerAussen:
      result := 'Berührung außen';
    bmEinerK1inK2:
      result := 'Berührung innen, K1 in K2';
    bmEinerK2inK1:
      result := 'Berührung innen, K2 in K1';
    bmK1inK2:
      result := 'K1 innerhalb K2';
    bmK2inK1:
      result := 'K2 innerhalb K1';
    bmRadiusFalsch:
      result := 'Radius Ungültig';
  end;
end;

procedure TSchnittKK.Schnitt;
var
  a, b, h1, h2, p, q, Entfernung: single;
  DeltaX, DeltaY: single;
  AbsDeltaX, AbsDeltaY: single;
  DeltaNullx, DeltaNully: Boolean;
  M1M2, M1S1, KreuzProd: TPoint3D;
  M1, M2, SP: TPoint3D;
begin
  NeedCalc := False;
  sv := False;
  Watch1 := 0;
  Watch2 := 0;

  S1 := TPoint3D.Zero;
  S2 := TPoint3D.Zero;

  if Ebene = seXY then
  begin
    M1.X := FM1.X;
    M1.Y := FM1.Y;
    M1.Z := 0;
    M2.X := FM2.X;
    M2.Y := FM2.Y;
    M2.Z := 0;
  end
  else if Ebene = seXZ then
  begin
    M1.X := FM1.X;
    M1.Y := FM1.Z;
    M1.Z := 0;
    M2.X := FM2.X;
    M2.Y := FM2.Z;
    M2.Z := 0;
  end
  else if Ebene = seYZ then
  begin
    M1.X := FM1.Y;
    M1.Y := FM1.Z;
    M1.Z := 0;
    M2.X := FM2.Y;
    M2.Y := FM2.Z;
    M2.Z := 0;
  end;

  if (R1 <= 0) or (R2 <= 0) then
  begin
    Bem := bmRadiusFalsch;
    Exit;
  end;

  DeltaX := M2.X - M1.X;
  DeltaY := M2.Y - M1.Y;
  DeltaNullx := DeltaX = 0;
  DeltaNully := DeltaY = 0;
  AbsDeltaX := abs(DeltaX);
  AbsDeltaY := abs(DeltaY);

  { Spezialfall konzentrische Kreise }
  if DeltaNullx and DeltaNully then
  begin
    Bem := bmKonzentrisch;
    Exit;
  end;

  h1 := (R1 * R1 - R2 * R2) + (M2.X * M2.X - M1.X * M1.X) + (M2.Y * M2.Y - M1.Y * M1.Y);

  { Rechnung im Normalfall }

  if AbsDeltaY > AbsDeltaX then
  begin
    Watch1 := 1;
    a := - DeltaX / DeltaY;
    b := h1 / (2 * DeltaY);
    p := 2 * (a * b - M1.X - a * M1.Y) / (1 + a * a);
    q := (M1.X * M1.X + b * b - 2 * b * M1.Y + M1.Y * M1.Y - R1 * R1) / (1 + a * a);
    h2 := p * p / 4 - q;
    if h2 >= 0 then
    begin
      h2 := sqrt(h2);
      S1.X := -p / 2 + h2;
      S2.X := -p / 2 - h2;
      S1.Y := a * S1.X + b;
      S2.Y := a * S2.X + b;
      sv := True;
    end;
  end
  else
  begin
    Watch1 := 2;
    a := - DeltaY / DeltaX;
    b := h1 / (2 * DeltaX);
    p := 2 * (a * b - M1.Y - a * M1.X) / (1 + a * a);
    q := (M1.Y * M1.Y + b * b - 2 * b * M1.X + M1.X * M1.X - R1 * R1) / (1 + a * a);
    h2 := p * p / 4 - q;
    if h2 >= 0 then
    begin
      h2 := sqrt(h2);
      S1.Y := -p / 2 + h2;
      S2.Y := -p / 2 - h2;
      S1.X := a * S1.Y + b;
      S2.X := a * S2.Y + b;
      sv := True;
    end;
  end;

  Entfernung := (M2 - M1).Length;

  if sv = False then
  begin
    if Entfernung > R1 + R2 then
      Bem := bmEntfernt
    else if Entfernung + R1 < R2 then
      Bem := bmK1inK2
    else if Entfernung + R2 < R1 then
      Bem := bmK2inK1;
    Exit;
  end;

  if sv = True then
  begin
    Bem := bmZwei;
    if Entfernung + R1 = R2 then
      Bem := bmEinerK1inK2
    else if Entfernung + R2 = R1 then
      Bem := bmEinerK2inK1
    else if Entfernung = R1 + R2 then
      Bem := bmEinerAussen;
  end;

  { den "richtigen" SchnittPunkt ermitteln }
  if Bem = bmZwei then
  begin
    Watch2 := 1;
    M1M2 := M2 - M1;
    M1S1 := S1 - M1;
    KreuzProd := M1M2.CrossProduct(M1S1);
    if KreuzProd.Z < 0 then
    begin
      Watch2 := 2;
      SP := S2;
      S2 := S1;
      S1 := SP;
    end;
  end;

  if Ebene = seXZ then
  begin
    S1.Z := S1.Y;
    S1.Y := 0;
    S2.Z := S2.Y;
    S2.Y := 0;
  end
  else if Ebene = seYZ then
  begin
    S1.X := S1.Y;
    S1.Y := S1.Z;
    S1.Z := 0;
    S2.X := S2.Y;
    S2.Y := S2.Z;
    S2.Z := 0;
  end;

end;

function TSchnittKK.GetRemark: string;
begin
  case Status of
    bmKonzentrisch:
      result := 'concentric circles';
    bmZwei:
      result := 'two intersections';
    bmEntfernt:
      result := 'two distant circles';
    bmEinerAussen:
      result := 'touching outside';
    bmEinerK1inK2:
      result := 'touching inside, C1 in C2';
    bmEinerK2inK1:
      result := 'touching inside, C2 in C1';
    bmK1inK2:
      result := 'C1 inside C2';
    bmK2inK1:
      result := 'C2 inside C1';
    bmRadiusFalsch:
      result := 'invalid radius';
  end;
end;

function TSchnittKK.IntersectionXZ(ASelector: Integer; AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
begin
  SchnittEbene := seXZ;
  Radius1 := AR1;
  Radius2 := AR2;
  MittelPunkt1 := AM1;
  MittelPunkt2 := AM2;
  if ASelector = 2 then
    result := SchnittPunkt2
  else
    result := SchnittPunkt1
end;

function TSchnittKK.IntersectionXZ1(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
begin
  result := IntersectionXZ(1, AM1, AM2, AR1, AR2);
end;

function TSchnittKK.IntersectionXZ2(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
begin
  result := IntersectionXZ(2, AM1, AM2, AR1, AR2);
end;

function TSchnittKK.AnglePointXZ(P: TPoint3D; R, AngleInRad: single): TPoint3D;
begin
  result.X := P.X + R * cos(AngleInRad);
  result.Z := P.Z + R * sin(AngleInRad);
  result.Y := 0;
end;

function TSchnittKK.AngleXZM(P1, P2: TPoint3D): single;
begin
  result := arctan2(P1.X - P2.X, P2.Z - P1.Z);
end;

function TSchnittKK.AngleXZ(P1, P2: TPoint3D): single;
begin
  result := arctan2(P1.X - P2.X, P1.Z - P2.Z);
end;

function TSchnittKK.AngleZXM(P1, P2: TPoint3D): single;
begin
  result := arctan2(P1.Z - P2.Z, P2.X - P1.X);
end;

function TSchnittKK.AngleZX(P1, P2: TPoint3D): single;
begin
  result := arctan2(P1.Z - P2.Z, P1.X - P2.X);
end;

{ TRggSchnittKK }

function TRggSchnittKK.AnglePoint(P: TRggPoint3D; R, AngleInRad: single): TPoint3D;
begin
  result := AnglePoint(P.C, R, AngleInRad);
end;

function TRggSchnittKK.AnglePoint(P: TPoint3D; R, AngleInRad: single): TPoint3D;
begin
  result.X := P.X + R * cos(AngleInRad);
  result.Y := P.Y - R * sin(AngleInRad);
  result.Z := 0;
end;

function TRggSchnittKK.Intersection(ASelector: Integer; AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
begin
  SchnittEbene := seXY;
  Radius1 := AR1;
  Radius2 := AR2;
  MittelPunkt1 := AM1;
  MittelPunkt2 := AM2;
  if ASelector = 2 then
    result := SchnittPunkt2
  else
    result := SchnittPunkt1
end;

function TRggSchnittKK.Intersection1(AM1, AM2: TRggPoint3D; AR1, AR2: single): TPoint3D;
begin
  result := Intersection1(AM1.C, AM2.C, AR1, AR2);
end;

function TRggSchnittKK.Intersection2(AM1, AM2: TRggPoint3D; AR1, AR2: single): TPoint3D;
begin
  result := Intersection2(AM1.C, AM2.C, AR1, AR2);
end;

function TRggSchnittKK.Intersection1(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
begin
  result := Intersection(1, AM1, AM2, AR1, AR2);
end;

function TRggSchnittKK.Intersection2(AM1, AM2: TPoint3D; AR1, AR2: single): TPoint3D;
begin
  result := Intersection(2, AM1, AM2, AR1, AR2);
end;

function TRggSchnittKK.AngleM(P1, P2: TPoint3D): single;
begin
  result := arctan2(P1.Y - P2.Z, P2.X - P1.Y);
end;

function TRggSchnittKK.Angle(P1, P2: TPoint3D): single;
begin
  result := arctan2(P1.Y - P2.Y, P1.X - P2.Y);
end;

function TRggSchnittKK.OuterAngle(P1, P2: TPoint3D): single;
begin
  result := arctan2((P1.X - P2.X), (P1.Y - P2.Y));
  result := Pi / 2 + result;
end;

class constructor TRggColors.Create;
begin
  Alpha := TAlphaColor($FF000000);

  Null := Alpha or TAlphaColor($FFFFFF);

  WindowWhite := Alpha or TAlphaColor($F0F0F0);

  ColorF9F9F9 := Alpha or TAlphaColor($F9F9F9);
  Color372E69 := Alpha or TAlphaColor($372E69);
  Color333333 := Alpha or TAlphaColor($333333);

  Aliceblue := Alpha or TAlphaColor($F0F8FF);
  Antiquewhite := Alpha or TAlphaColor($FAEBD7);
  Aqua := Alpha or TAlphaColor($00FFFF);
  Aquamarine := Alpha or TAlphaColor($7FFFD4);
  Azure := Alpha or TAlphaColor($F0FFFF);
  Beige := Alpha or TAlphaColor($F5F5DC);
  Bisque := Alpha or TAlphaColor($FFE4C4);
  Black := Alpha or TAlphaColor($000000);
  Blanchedalmond := Alpha or TAlphaColor($FFEBCD);
  Blue := Alpha or TAlphaColor($0000FF);
  Blueviolet := Alpha or TAlphaColor($8A2BE2);
  Brown := Alpha or TAlphaColor($A52A2A);
  Burlywood := Alpha or TAlphaColor($DEB887);
  Cadetblue := Alpha or TAlphaColor($5F9EA0);
  Chartreuse := Alpha or TAlphaColor($7FFF00);
  Chocolate := Alpha or TAlphaColor($D2691E);
  Coral := Alpha or TAlphaColor($FF7F50);
  Cornflowerblue := Alpha or TAlphaColor($6495ED);
  Cornsilk := Alpha or TAlphaColor($FFF8DC);
  Crimson := Alpha or TAlphaColor($DC143C);
  Cyan := Alpha or TAlphaColor($00FFFF);
  Darkblue := Alpha or TAlphaColor($00008B);
  Darkcyan := Alpha or TAlphaColor($008B8B);
  Darkgoldenrod := Alpha or TAlphaColor($B8860B);
  Darkgray := Alpha or TAlphaColor($A9A9A9);
  Darkgreen := Alpha or TAlphaColor($006400);
  Darkgrey := Alpha or TAlphaColor($A9A9A9);
  Darkkhaki := Alpha or TAlphaColor($BDB76B);
  Darkmagenta := Alpha or TAlphaColor($8B008B);
  Darkolivegreen := Alpha or TAlphaColor($556B2F);
  Darkorange := Alpha or TAlphaColor($FF8C00);
  Darkorchid := Alpha or TAlphaColor($9932CC);
  Darkred := Alpha or TAlphaColor($8B0000);
  Darksalmon := Alpha or TAlphaColor($E9967A);
  Darkseagreen := Alpha or TAlphaColor($8FBC8F);
  Darkslateblue := Alpha or TAlphaColor($483D8B);
  Darkslategray := Alpha or TAlphaColor($2F4F4F);
  Darkslategrey := Alpha or TAlphaColor($2F4F4F);
  Darkturquoise := Alpha or TAlphaColor($00CED1);
  Darkviolet := Alpha or TAlphaColor($9400D3);
  Deeppink := Alpha or TAlphaColor($FF1493);
  Deepskyblue := Alpha or TAlphaColor($00BFFF);
  Dimgray := Alpha or TAlphaColor($696969);
  Dimgrey := Alpha or TAlphaColor($696969);
  Dodgerblue := Alpha or TAlphaColor($1E90FF);
  Firebrick := Alpha or TAlphaColor($B22222);
  Floralwhite := Alpha or TAlphaColor($FFFAF0);
  Forestgreen := Alpha or TAlphaColor($228B22);
  Fuchsia := Alpha or TAlphaColor($FF00FF);
  Gainsboro := Alpha or TAlphaColor($DCDCDC);
  Ghostwhite := Alpha or TAlphaColor($F8F8FF);
  Gold := Alpha or TAlphaColor($FFD700);
  Goldenrod := Alpha or TAlphaColor($DAA520);
  Gray := Alpha or TAlphaColor($808080);
  Green := Alpha or TAlphaColor($008000);
  Greenyellow := Alpha or TAlphaColor($ADFF2F);
  Grey := Alpha or TAlphaColor($808080);
  Honeydew := Alpha or TAlphaColor($F0FFF0);
  Hotpink := Alpha or TAlphaColor($FF69B4);
  Indianred := Alpha or TAlphaColor($CD5C5C);
  Indigo := Alpha or TAlphaColor($4B0082);
  Ivory := Alpha or TAlphaColor($FFFFF0);
  Khaki := Alpha or TAlphaColor($F0E68C);
  Lavender := Alpha or TAlphaColor($E6E6FA);
  Lavenderblush := Alpha or TAlphaColor($FFF0F5);
  Lawngreen := Alpha or TAlphaColor($7CFC00);
  Lemonchiffon := Alpha or TAlphaColor($FFFACD);
  Lightblue := Alpha or TAlphaColor($ADD8E6);
  Lightcoral := Alpha or TAlphaColor($F08080);
  Lightcyan := Alpha or TAlphaColor($E0FFFF);
  Lightgoldenrodyellow := Alpha or TAlphaColor($FAFAD2);
  Lightgray := Alpha or TAlphaColor($D3D3D3);
  Lightgreen := Alpha or TAlphaColor($90EE90);
  Lightgrey := Alpha or TAlphaColor($D3D3D3);
  Lightpink := Alpha or TAlphaColor($FFB6C1);
  Lightsalmon := Alpha or TAlphaColor($FFA07A);
  Lightseagreen := Alpha or TAlphaColor($20B2AA);
  Lightskyblue := Alpha or TAlphaColor($87CEFA);
  Lightslategray := Alpha or TAlphaColor($778899);
  Lightslategrey := Alpha or TAlphaColor($778899);
  Lightsteelblue := Alpha or TAlphaColor($B0C4DE);
  Lightyellow := Alpha or TAlphaColor($FFFFE0);
  LtGray := Alpha or TAlphaColor($C0C0C0);
  MedGray := Alpha or TAlphaColor($A0A0A0);
  DkGray := Alpha or TAlphaColor($808080);
  MoneyGreen := Alpha or TAlphaColor($C0DCC0);
  LegacySkyBlue := Alpha or TAlphaColor($F0CAA6);
  Cream := Alpha or TAlphaColor($F0FBFF);
  Lime := Alpha or TAlphaColor($00FF00);
  Limegreen := Alpha or TAlphaColor($32CD32);
  Linen := Alpha or TAlphaColor($FAF0E6);
  Magenta := Alpha or TAlphaColor($FF00FF);
  Maroon := Alpha or TAlphaColor($800000);
  Mediumaquamarine := Alpha or TAlphaColor($66CDAA);
  Mediumblue := Alpha or TAlphaColor($0000CD);
  Mediumorchid := Alpha or TAlphaColor($BA55D3);
  Mediumpurple := Alpha or TAlphaColor($9370DB);
  Mediumseagreen := Alpha or TAlphaColor($3CB371);
  Mediumslateblue := Alpha or TAlphaColor($7B68EE);
  Mediumspringgreen := Alpha or TAlphaColor($00FA9A);
  Mediumturquoise := Alpha or TAlphaColor($48D1CC);
  Mediumvioletred := Alpha or TAlphaColor($C71585);
  Midnightblue := Alpha or TAlphaColor($191970);
  Mintcream := Alpha or TAlphaColor($F5FFFA);
  Mistyrose := Alpha or TAlphaColor($FFE4E1);
  Moccasin := Alpha or TAlphaColor($FFE4B5);
  Navajowhite := Alpha or TAlphaColor($FFDEAD);
  Navy := Alpha or TAlphaColor($000080);
  Oldlace := Alpha or TAlphaColor($FDF5E6);
  Olive := Alpha or TAlphaColor($808000);
  Olivedrab := Alpha or TAlphaColor($6B8E23);
  Orange := Alpha or TAlphaColor($FFA500);
  Orangered := Alpha or TAlphaColor($FF4500);
  Orchid := Alpha or TAlphaColor($DA70D6);
  Palegoldenrod := Alpha or TAlphaColor($EEE8AA);
  Palegreen := Alpha or TAlphaColor($98FB98);
  Paleturquoise := Alpha or TAlphaColor($AFEEEE);
  Palevioletred := Alpha or TAlphaColor($DB7093);
  Papayawhip := Alpha or TAlphaColor($FFEFD5);
  Peachpuff := Alpha or TAlphaColor($FFDAB9);
  Peru := Alpha or TAlphaColor($CD853F);
  Pink := Alpha or TAlphaColor($FFC0CB);
  Plum := Alpha or TAlphaColor($DDA0DD);
  Powderblue := Alpha or TAlphaColor($B0E0E6);
  Purple := Alpha or TAlphaColor($800080);
  Red := Alpha or TAlphaColor($FF0000);
  Rosybrown := Alpha or TAlphaColor($BC8F8F);
  Royalblue := Alpha or TAlphaColor($4169E1);
  Saddlebrown := Alpha or TAlphaColor($8B4513);
  Salmon := Alpha or TAlphaColor($FA8072);
  Sandybrown := Alpha or TAlphaColor($F4A460);
  Seagreen := Alpha or TAlphaColor($2E8B57);
  Seashell := Alpha or TAlphaColor($FFF5EE);
  Sienna := Alpha or TAlphaColor($A0522D);
  Silver := Alpha or TAlphaColor($C0C0C0);
  Skyblue := Alpha or TAlphaColor($87CEEB);
  Slateblue := Alpha or TAlphaColor($6A5ACD);
  Slategray := Alpha or TAlphaColor($708090);
  Slategrey := Alpha or TAlphaColor($708090);
  Snow := Alpha or TAlphaColor($FFFAFA);
  Springgreen := Alpha or TAlphaColor($00FF7F);
  Steelblue := Alpha or TAlphaColor($4682B4);
  Tan := Alpha or TAlphaColor($D2B48C);
  Teal := Alpha or TAlphaColor($008080);
  Thistle := Alpha or TAlphaColor($D8BFD8);
  Tomato := Alpha or TAlphaColor($FF6347);
  Turquoise := Alpha or TAlphaColor($40E0D0);
  Violet := Alpha or TAlphaColor($EE82EE);
  Wheat := Alpha or TAlphaColor($F5DEB3);
  White := Alpha or TAlphaColor($FFFFFF);
  Whitesmoke := Alpha or TAlphaColor($F5F5F5);
  Yellow := Alpha or TAlphaColor($FFFF00);
  Yellowgreen := Alpha or TAlphaColor($9ACD32);
end;

class function TRggColors.ColorFromRGB(R, G, B: Byte): TRggColor;
var
  acr: TAlphaColorRec;
begin
  acr.R := R;
  acr.G := G;
  acr.B := B;
  acr.A := 255;
  result := acr.Color;
end;

{ TRggPoint3D }

class operator TRggPoint3D.Add(const APoint1, APoint2: TRggPoint3D): TRggPoint3D;
begin
  Result.X := APoint1.X + APoint2.X;
  Result.Y := APoint1.Y + APoint2.Y;
  Result.Z := APoint1.Z + APoint2.Z;
end;

class operator TRggPoint3D.Subtract(const APoint1, APoint2: TRggPoint3D): TRggPoint3D;
begin
  Result.X := APoint1.X - APoint2.X;
  Result.Y := APoint1.Y - APoint2.Y;
  Result.Z := APoint1.Z - APoint2.Z;
end;

function TRggPoint3D.Length: Single;
begin
  result := C.Length;
end;

function TRggPoint3D.Normalize: TRggPoint3D;
begin
  C := C.Normalize;
  result := self;
end;

function TRggPoint3D.Rotate(const AAngle: Single): TRggPoint3D;
var
  Sine, Cosine: Single;
begin
  Sine := sin(AAngle);
  Cosine := cos(AAngle);
  Result.X := X * Cosine - Y * Sine;
  Result.Y := X * Sine + Y * Cosine;
end;

function TRggPoint3D.Angle(const APoint: TRggPoint3D): single;
begin
  Result := Arctan2(Self.Y - APoint.Y, Self.X - APoint.X);
end;

function TRggPoint3D.Distance(const APoint: TRggPoint3D): single;
begin
  Result := (Self - APoint).Length;
end;

class function TRggPoint3D.Zero: TRggPoint3D;
begin
  result.C := TPoint3D.Zero;
end;

{ TRggElement }

constructor TRggElement.Create;
begin
  Visible := True;
  FOpacity := 1.0;
  FStrokeThickness := 3.0;
  FStrokeColor := TRggColors.Red;
  FStrokeDash := TStrokeDash.Solid;
  TypeName := 'Element';
  TextRadius := DefaultTextRadius;
  TextAngle := DefaultTextAngle;
end;

procedure TRggElement.GetInfo(ML: TStrings);
begin
  if Caption = '' then
    ML.Add('Element has no Caption');
end;

function TRggElement.GetValid: Boolean;
begin
  result := Caption <> '';
end;

function TRggElement.GetListCaption: string;
begin
  result := TypeName + ' ' + Caption;
  if IsComputed or IndentItem then
    result := '-- ' + result
end;

procedure TRggElement.Param1(Delta: single);
begin

end;

procedure TRggElement.Param2(Delta: single);
begin

end;

procedure TRggElement.Param3(Delta: single);
begin

end;

procedure TRggElement.SetOpacity(const Value: single);
begin
  FOpacity := Value;
end;

procedure TRggElement.SetStrokeColor(const Value: TAlphaColor);
begin
  FStrokeColor := Value;
end;

procedure TRggElement.SetStrokeDash(const Value: TStrokeDash);
begin
  FStrokeDash := Value;
end;

procedure TRggElement.SetStrokeThickness(const Value: single);
begin
  FStrokeThickness := Value;
end;

procedure TRggElement.TextOut(g: TCanvas; s: string);
var
  R: TRectF;
  x, y: single;
  w, h: single;
begin
  w := 100;
  h := 12;
  x := TextCenter.X + TextRadius * cos(TextAngle);
  y := TextCenter.Y + TextRadius * sin(TextAngle);
  R := RectF(x - w, y - h, x + w, y + h);

  { FMX }
  if WantTextRect then
    g.DrawRect(R, 0, 0, [], 1.0);
  g.FillText(
    R,
    s,
    false, // WordWrap
    1.0, // Opacity
    [], // [TFillTextFlag.RightToLeft],
    TTextAlign.Center,
    TTextAlign.Center);
end;

procedure TRggElement.TextOutLeading(g: TCanvas; s: string);
var
  R: TRectF;
  x, y: single;
  w, h: single;
begin
  w := 200;
  h := 24;
  x := TextCenter.X + TextRadius * cos(TextAngle);
  y := TextCenter.Y + TextRadius * sin(TextAngle);
  R := RectF(x, y, x + w, y + h);

  { FMX }
  if WantTextRect then
    g.DrawRect(R, 0, 0, [], 1.0);
  g.FillText(
    R,
    s,
    false, // WordWrap
    1.0, // Opacity
    [], // [TFillTextFlag.RightToLeft],
    TTextAlign.Leading,
    TTextAlign.Leading);
end;

procedure TRggElement.Transform;
begin

end;

procedure TRggElement.Param7(Delta: single);
begin
  TextAngle := TextAngle + DegToRad(Delta);
end;

procedure TRggElement.Param8(Delta: single);
begin
  TextRadius := TextRadius + Delta;
end;

procedure TRggElement.Draw(g: TCanvas);
begin
  TextOut(g, Caption);
end;

{ TRggCircle }

constructor TRggCircle.Create;
begin
  inherited;
  { Matrix is a class var but we will reset it always. }
  Matrix := TMatrix3D.Identity;
  TypeName := 'Circle';
  StrokeThickness := 2.0;
  FRadius := 10;
  Center.X := 100;
  Center.Y := 100;
  ShowCaption := DefaultShowCaption;
end;

constructor TRggCircle.Create(ACaption: string);
begin
  Create;
  Caption := ACaption;
end;

procedure TRggCircle.Draw(g: TCanvas);
var
  R: TRectF;
begin
  if not Visible then
    Exit;

  Temp1 := Center + Drawing.FaxPoint3D;

  if Radius > 5 then
  begin
    R := RectF(
      Temp1.X - FRadius,
      Temp1.Y - FRadius,
      Temp1.X + FRadius,
      Temp1.Y + FRadius);

    g.Fill.Color := Drawing.Colors.BackgroundColor;
    g.FillEllipse(R, Opacity);

    g.Stroke.Color := StrokeColor;
    g.Stroke.Thickness := StrokeThickness;
    g.DrawEllipse(R, Opacity);
  end;

  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := Drawing.Colors.TextColor;
    TextCenter := Temp1.P;
    TextOut(g, Caption);
  end;
end;

procedure TRggCircle.Param1(Delta: single);
begin
  OriginalCenter.X := OriginalCenter.X + Delta;
  Center := OriginalCenter;
end;

procedure TRggCircle.Param2(Delta: single);
begin
  OriginalCenter.Y := OriginalCenter.Y + Delta;
  Center := OriginalCenter;
end;

procedure TRggCircle.Param1I(Delta: single);
begin
  Center.X := Center.X + Delta;
  OriginalCenter := Center;
end;

procedure TRggCircle.Param2I(Delta: single);
begin
  Center.Y := Center.Y + Delta;
  OriginalCenter := Center;
end;

procedure TRggCircle.Param3(Delta: single);
begin
  OriginalCenter.Z := OriginalCenter.Z + Delta;
  Center := OriginalCenter;
end;

procedure TRggCircle.Reset;
begin
  Center := OriginalCenter;
  TextAngle := DefaultTextAngle;
  TextRadius := DefaultTextRadius;
end;

procedure TRggCircle.Save;
begin
  OriginalCenter := Center;
end;

procedure TRggCircle.SetRadius(const Value: single);
begin
  FRadius := Value;
end;

procedure TRggCircle.Transform;
begin
  Center.C := Center.C * Matrix;
end;

procedure TRggCircle.TransformI;
begin
  OriginalCenter.C := OriginalCenter.C * Matrix;
end;

procedure TRggCircle.WriteCode(ML: TStrings);
begin
  ML.Add(Format('cr := Find(''%s'');', [Caption]));
  ML.Add(Format('cr.Center.X := %.2f;', [Center.X]));
  ML.Add(Format('cr.Center.Y := %.2f;', [Center.Y]));
  ML.Add(Format('cr.Center.Z := %.2f;', [Center.Z]));

  if TextAngle <> DefaultTextAngle then
    ML.Add(Format('cr.TextAngle := %.2f;', [RadToDeg(TextAngle)]));
  if TextRadius <> DefaultTextRadius then
    ML.Add(Format('cr.TextRadius := %.2f;', [TextRadius]));

  ML.Add('');
end;

function TRggCircle.IsEqual(B: TRggCircle): Boolean;
begin
  result := Center.C = B.Center.C;
end;

function TRggCircle.CompareZ(Q: TRggCircle): Integer;
begin
  if Center.Z > Q.Center.Z then
    result := 1
  else if Center.Z < Q.Center.Z then
    result := -1
  else
    result := 0;
end;

class function TRggCircle.Compare(const Left, Right: TRggCircle): Integer;
begin
  result := Left.CompareZ(Right);
end;

{ TRggLine }

constructor TRggLine.Create(ACaption: string);
begin
  inherited Create;
  TypeName := 'Line';
  Caption := ACaption;
  ShowCaption := DefaultShowCaption;
end;

procedure TRggLine.GetInfo(ML: TStrings);
begin
  inherited;
  if Point1 = nil then
    ML.Add(Caption + '.Point1 = nil');
  if Point2 = nil then
    ML.Add(Caption + '.Point2 = nil');
end;

function TRggLine.GetValid: Boolean;
begin
  result := inherited;
  result := result and (Point1 <> nil);
  result := result and (Point2 <> nil);
end;

procedure TRggLine.Draw(g: TCanvas);
begin
  if not Visible then
    Exit;

  Temp1 := Point1.Center + Drawing.FaxPoint3D;
  Temp2 := Point2.Center + Drawing.FaxPoint3D;

  g.Stroke.Thickness := StrokeThickness;
  g.Stroke.Color := StrokeColor;
  g.Stroke.Dash := StrokeDash;
  g.DrawLine(Temp1.P, Temp2.P, Opacity);
  g.Stroke.Dash := TStrokeDash.Solid;

  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := Drawing.Colors.TextColor;
    TextCenter := Temp1.P + (Temp2.P - Temp1.P) * 0.5;
    TextOut(g, Caption);
  end;
end;

function TRggLine.GetLength: single;
begin
  result := (Point2.Center.C - Point1.Center.C).Length;
end;

procedure TRggLine.Param1(Delta: single);
var
  u, v: TPointF;
begin
  { change length of line element, change Point2 }
  u := V2 * (1 + Delta / 100);
  v := Point1.Center.P + u;

  Point2.OriginalCenter.P := v;
  Point2.Center := Point2.OriginalCenter;
end;

procedure TRggLine.Param2(Delta: single);
var
  alpha: single;
begin
  { rotate line around Point2 }
  alpha := DegToRad(-Delta / 5);

  Point2.OriginalCenter.P := Point1.Center.P + V2.Rotate(alpha);
  Point2.Center := Point2.OriginalCenter;
end;

function TRggLine.V2: TPointF;
begin
  result := Point2.Center.P - Point1.Center.P;
end;

function TRggLine.V3: TPoint3D;
begin
  result := Point2.Center.C - Point1.Center.C;
end;

function TRggLine.IsTotallyAbove(Other: TRggLine): Boolean;
begin
  result :=
    (Point1.Center.Z > Other.Point1.Center.Z) and
    (Point1.Center.Z > Other.Point2.Center.Z) and
    (Point2.Center.Z > Other.Point1.Center.Z) and
    (Point2.Center.Z > Other.Point2.Center.Z);
end;

function TRggLine.IsTotallyBelow(Other: TRggLine): Boolean;
begin
  result :=
    (Point1.Center.Z < Other.Point1.Center.Z) and
    (Point1.Center.Z < Other.Point2.Center.Z) and
    (Point2.Center.Z < Other.Point1.Center.Z) and
    (Point2.Center.Z < Other.Point2.Center.Z);
end;

function TRggLine.IsSame(Other: TRggLine): Boolean;
begin
  result := False;
  if Point1.IsEqual(Other.Point1) and Point2.IsEqual(Other.Point2) then
    result := True
  else if Point1.IsEqual(Other.Point2) and Point2.IsEqual(Other.Point1) then
    result := True;
end;

function TRggLine.ComputeSPZ(SP: TPoint3D): single;
var
  vSP: TPoint3D;
  vAB: TPoint3D;

  vABxy: TPointF;
  vSPxy: TPointF;
  lengthABxy, lengthSPxy: single;
  RatioSPtoAB, g: single;
begin
  result := (Point1.Center.Z + Point2.Center.Z) / 2;

  vSP := SP - Point1.Center.C;
  vAB := Point2.Center.C - Point1.Center.C;

  vABxy := TPointF.Create(vAB.X, vAB.Y);
  lengthABxy := vABxy.Length;

  vSPxy := TPointF.Create(vSP.X, vSP.Y);
  lengthSPxy := vSPxy.Length;

  if lengthABxy < Eps then
  begin
    Exit;
  end;

  RatioSPtoAB := lengthSPxy / lengthABxy;

  g := RatioSPtoAB;

  if Sign(vAB.X) <> Sign(vSP.X) then
    g := -RatioSPtoAB;

  if Abs(g) > 10000 then
  begin
    { does not come in here }
    result := Point1.Center.Z;
    Exit;
  end;

  result := Point1.Center.Z + g * vAB.Z;
end;

procedure TRggLine.ReportData(ML: TStrings);
  procedure AddPoint(LN, PN: string; P: TPoint3D);
  begin
    ML.Add(Format('%s [%s] = (%.2f, %.2f, %.2f)', [PN, LN, P.X, P.Y, P.Z]));
  end;
begin
  AddPoint(Caption, 'A', Point1.Center.C);
  AddPoint(Caption, 'B', Point2.Center.C);
end;

class procedure TRggLine.ResetCounter;
begin
  CounterLeftNil := 0;
  CounterRightNil := 0;
  CounterHardcodedAbove := 0;
  CounterHardcodedBelow := 0;
  CounterSame := 0;
  CounterTotallyAbove := 0;
  CounterTotallyBelow := 0;
  CounterCommon := 0;
  CounterParallel := 0;
  CounterSPZ := 0;
  CounterZero := 0;
end;

class function TRggLine.CounterSum: Integer;
begin
  result :=
    CounterLeftNil +
    CounterRightNil +
    CounterHardCodedAbove +
    CounterHardCodedBelow +
    CounterSame +
    CounterTotallyAbove +
    CounterTotallyBelow +
    CounterCommon +
    CounterParallel +
    CounterSPZ;
end;

class function TRggLine.Compare(const Left, Right: TRggLine): Integer;
var
  LP: TRggLinePair;
  r: Integer;
begin
  if Left = nil then
  begin
    Left.Bemerkung := ccNil;
    Inc(CounterLeftNil);
    result := 0;
    Exit;
  end;

  if Right = nil then
  begin
    Left.Bemerkung := ccNil;
    Inc(CounterRightNil);
    result := 0;
    Exit;
  end;

  LP.SP := TPoint3D.Zero;
  LP.L1 := Left;
  LP.L2 := Right;

  if False then

  else if LP.L1.IsSame(LP.L2) then
  begin
    Inc(CounterSame);
    Left.Bemerkung := ccTotallySame;
    r := 0;
    Dec(CounterZero); // compensate for Inc below
  end

  else if LP.L1.IsTotallyAbove(LP.L2) then
  begin
    Inc(CounterTotallyAbove);
    Left.Bemerkung := ccTotallyAbove;
    r := 1;
  end

  else if LP.L1.IsTotallyBelow(LP.L2) then
  begin
    Inc(CounterTotallyBelow);
    Left.Bemerkung := ccTotallyBelow;
    r := -1;
  end

  else if LP.HasCommonPoint then
  begin
    Inc(CounterCommon);
    r := LP.CompareCommon;
    case r of
      0: Left.Bemerkung := ccCommonSame;
      1: Left.Bemerkung := ccCommonAbove;
      -1: Left.Bemerkung := ccCommonBelow;
      else
        Left.Bemerkung := ccCommonNone;
    end;
  end

  { As a side effect, this call to IsParallel will set SP }
  else if LP.IsParallel then
  begin
    Inc(CounterParallel);
    Left.Bemerkung := ccParallel;
    r := 0;
  end

  else
  begin
    Inc(CounterSPZ);
    r := LP.CompareSPZ;
    case r of
      0: Left.Bemerkung := ccSame;
      1: Left.Bemerkung := ccAbove;
      -1: Left.Bemerkung := ccBelow;
      else
        Left.Bemerkung := ccNone;
    end;
  end;

  if r = 0 then
  begin
    Inc(CounterZero);
  end;

  result := r;
end;

{ TRggTriangle }

procedure TRggTriangle.GetInfo(ML: TStrings);
begin
  inherited;
  if Point1 = nil then
    ML.Add(Caption + '.Point1 = nil');
  if Point2 = nil then
    ML.Add(Caption + '.Point2 = nil');
  if Point3 = nil then
    ML.Add(Caption + '.Point3 = nil');
end;

function TRggTriangle.GetValid: Boolean;
begin
  result := inherited;
  result := result and (Point1 <> nil);
  result := result and (Point2 <> nil);
  result := result and (Point3 <> nil);
end;

constructor TRggTriangle.Create;
begin
  inherited;
  TypeName := 'Triangle';
  IndentItem := True;
  SetLength(Poly, 3);
end;

procedure TRggTriangle.Draw(g: TCanvas);
begin
  Poly[0] := (Point1.Center + Drawing.FaxPoint3D).P;
  Poly[1] := (Point2.Center + Drawing.FaxPoint3D).P;
  Poly[2] := (Point3.Center + Drawing.FaxPoint3D).P;
  g.Fill.Color := StrokeColor;
  g.FillPolygon(Poly, 0.7);
end;

{ TRggArc }

function TRggArc.GetValid: Boolean;
begin
  result := inherited;
  result := result and (Point1 <> nil);
  result := result and (Point2 <> nil);
  result := result and (Point3 <> nil);
end;

constructor TRggArc.Create(ACaption: string);
begin
  inherited Create;
  FTextRadiusFactor := 1.2;
  Caption := ACaption;
  IndentItem := True;
  TypeName := 'Arc';
  Radius := 50;
  StrokeThickness := 2;
  ShowCaption := True;
end;

procedure TRggArc.Draw(g: TCanvas);
var
  Angle2, Angle3: single;
  startAngle: single;
  sweepAngle: single;
  s: string;
begin
  Temp1 := Point1.Center + Drawing.FaxPoint3D;
  Temp2 := Point2.Center + Drawing.FaxPoint3D;
  Temp3 := Point3.Center + Drawing.FaxPoint3D;

  Angle2 := RadToDeg(Temp2.P.Angle(Temp1.P));
  Angle3 := RadToDeg(Temp3.P.Angle(Temp1.P));

  startAngle := Angle3;
  sweepAngle := (Angle2 - Angle3);

  if sweepAngle < -180 then
  begin
    sweepAngle := sweepAngle + 360;
  end;

  if sweepAngle > 180 then
  begin
    sweepAngle := sweepAngle - 360;
  end;

  s := Caption;

  g.Stroke.Color := StrokeColor;
  g.Stroke.Thickness := StrokeThickness;
  g.DrawArc(Temp1.P, RadiusF, startAngle, sweepAngle, Opacity);

  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := Drawing.Colors.TextColor;
    TextAngle := DegToRad(startAngle + sweepAngle / 2);
    TextRadius := Radius * FTextRadiusFactor;
    TextCenter := Temp1.P;
    TextOut(g, s);
  end;
end;

procedure TRggArc.GetInfo(ML: TStrings);
begin
  inherited;
  if Point1 = nil then
    ML.Add(Caption + '.Point1 = nil');
  if Point2 = nil then
    ML.Add(Caption + '.Point2 = nil');
  if Point3 = nil then
    ML.Add(Caption + '.Point3 = nil');
end;

function TRggArc.GetSweepAngle: single;
var
  Angle2, Angle3: single;
  sweepAngle: single;
begin
  Angle2 := RadToDeg(Point2.Center.P.Angle(Point1.Center.P));
  Angle3 := RadToDeg(Point3.Center.P.Angle(Point1.Center.P));

  sweepAngle := (Angle2 - Angle3);
  result := sweepAngle;
end;

procedure TRggArc.SetRadius(const Value: single);
begin
  FRadius := Value;
  RadiusF.X := FRadius;
  RadiusF.Y := FRadius;
end;

procedure TRggArc.Param1(Delta: single);
begin
  Radius := Radius + Delta;
end;

procedure TRggArc.Param2(Delta: single);
begin
  FTextRadiusFactor := FTextRadiusFactor + Delta / 50;
end;

{ TRggLagerLine }

procedure TRggLagerLine.Draw(g: TCanvas);
begin
  inherited;
  DrawLager(g, (Drawing.FaxPoint3D + Point1.Center).P, True);
  DrawLager(g, (Drawing.FaxPoint3D + Point2.Center).P, False);
end;

procedure TRggLagerLine.DrawLager(g: TCanvas; P: TPointF; FestLager: Boolean);
var
  Angle: single;
  l: single;
  d: single;

  TempA: TPointF;
  TempB: TPointF;
  TempC: TPointF;
  TempD: TPointF;

  TempE: TPointF;
  TempF: TPointF;

  o: TPointF;
  TempP: TPolygon;
  i: Integer;
begin
  Angle := DegToRad(30);
  l := 30;

  TempA.X := cos(Angle) * Point1.FRadius;
  TempA.Y := -sin(Angle) * Point1.FRadius;
  TempB.X := TempA.X + sin(Angle) * l;
  TempB.Y := TempA.Y + cos(Angle) * l;
  TempC.X := -TempB.X;
  TempC.Y := TempB.Y;
  TempD.X := -TempA.X;
  TempD.Y := TempA.Y;
  o.X := P.X;
  o.Y := P.Y;

  TempA.Offset(o);
  TempB.Offset(o);
  TempC.Offset(o);
  TempD.Offset(o);

  SetLength(TempP, 4);
  TempP[0] := TempA;
  TempP[1] := TempB;
  TempP[2] := TempC;
  TempP[3] := TempD;

  g.Stroke.Join := TStrokeJoin.Round;
  g.Stroke.Cap := TStrokeCap.Round;
  g.Stroke.Color := TRggColors.Gray;
  g.Stroke.Thickness := 3.0;
  g.DrawPolygon(TempP, Opacity);

  if not FestLager then
  begin
    o.X := 0;
    o.Y := 5;
    TempB.Offset(o);
    TempC.Offset(o);
    g.DrawLine(TempB, TempC, Opacity);
  end;

  TempE := TempC;
  TempF.X := TempE.X - sin(Angle) * l * 0.5;
  TempF.Y := TempE.Y + cos(Angle) * l * 0.5;

  d := (TempB - TempC).Length / 3;

  o.X := -0.4 * d;
  o.Y := 0;
  TempE.Offset(o);
  TempF.Offset(o);

  o.X := d;
  o.Y := 0;
  for i := 1 to 3 do
  begin
    TempE.Offset(o);
    TempF.Offset(o);
    g.DrawLine(TempE, TempF, Opacity);
  end;
end;

{ TRggLinePair }

function TRggLinePair.CompareVV(v1, v2: TPoint3D): Integer;
var
  m1, m2: TPoint3D;
  r: single;
begin
  m1 := v1.Normalize;
  m2 := v2.Normalize;
  r := m2.Z - m1.Z;
  if r > 0 then
    result := -1
  else if r < 0 then
    result := 1
  else
    result := 0;
end;

procedure TRggLinePair.ReportData(ML: TStrings);
  procedure AddPoint(LN, PN: string; P: TPoint3D);
  begin
    ML.Add(Format('%s [%s] = (%.2f, %.2f, %.2f)', [PN, LN, P.X, P.Y, P.Z]));
  end;
begin
  AddPoint(L1.Caption, 'A', L1.Point1.Center.C);
  AddPoint(L1.Caption, 'B', L1.Point2.Center.C);
  AddPoint(L2.Caption, 'C', L2.Point1.Center.C);
  AddPoint(L2.Caption, 'D', L2.Point2.Center.C);
end;

function TRggLinePair.CompareSPZ: Integer;
var
  za, zb, dz: single;
begin
  za := L1.ComputeSPZ(SP);
  zb := L2.ComputeSPZ(SP);

  dz := zb - za;

  if dz > 0 then
    result := -1
  else if dz < 0 then
    result := 1
  else
    result := 0;
end;

function TRggLinePair.HasCommonPoint: Boolean;
begin
  result :=
    (L1.Point1.Center.C = L2.Point1.Center.C) or
    (L1.Point1.Center.C = L2.Point2.Center.C) or
    (L1.Point2.Center.C = L2.Point1.Center.C) or
    (L1.Point2.Center.C = L2.Point2.Center.C);
end;

function TRggLinePair.IsParallel: Boolean;
begin
  result := not SchnittGG;
end;

function TRggLinePair.CompareCommon: Integer;
var
  v1, v2: TPoint3D;
begin
  result := 0;
  if L1.Point1.IsEqual(L2.Point1) then
  begin
    v1 := L1.Point2.Center.C - L1.Point1.Center.C;
    v2 := L2.Point2.Center.C - L2.Point1.Center.C;
    result := CompareVV(v1, v2);
  end
  else if L1.Point1.IsEqual(L2.Point2) then
  begin
    v1 := L1.Point2.Center.C - L1.Point1.Center.C;
    v2 := L2.Point1.Center.C - L2.Point2.Center.C;
    result := CompareVV(v1, v2);
  end
  else if L1.Point2.IsEqual(L2.Point1) then
  begin
    v1 := L1.Point1.Center.C - L1.Point2.Center.C;
    v2 := L2.Point2.Center.C - L2.Point1.Center.C;
    result := CompareVV(v1, v2);
  end
  else if L1.Point2.IsEqual(L2.Point2) then
  begin
    v1 := L1.Point1.Center.C - L1.Point2.Center.C;
    v2 := L2.Point1.Center.C - L2.Point2.Center.C;
    result := CompareVV(v1, v2);
  end;
end;

function TRggLinePair.SchnittGG: Boolean;
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

  x1 := L1.Point1.Center.X;
  z1 := L1.Point1.Center.Z;
  x3 := L2.Point1.Center.X;
  z3 := L2.Point1.Center.X;

  Quotient := L1.Point2.Center.X - L1.Point1.Center.X;
  if abs(Quotient) > 0.001 then
    a1 := (L1.Point2.Center.Z - L1.Point1.Center.Z) / Quotient
  else
    Fall := g1Vertical;

  Quotient := L2.Point2.Center.X - L2.Point1.Center.X;
  if abs(Quotient) > 0.001 then
    a2 := (L2.Point2.Center.Z - L1.Point1.Center.Z) / Quotient
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

{ TRggLabel }

constructor TRggLabel.Create;
begin
  inherited;
  TypeName := 'Label';
  Position.X := 20;
  Position.Y := 20;
end;

procedure TRggLabel.Draw(g: TCanvas);
var
  R: TRectF;
  x, y: single;
  w, h: single;
begin
  TextCenter := Position;

  w := 500;
  h := 24;
  x := TextCenter.X;
  y := TextCenter.Y;

  if IsMemoLabel then
  begin
    w := 620;
    h := 700;
  end;

  R := RectF(x, y, x + w, y + h);

  g.Fill.Color := Drawing.Colors.LabelColor;
  g.Stroke.Color := Drawing.Colors.LabelColor;

  g.FillText(
    R,
    Text,
    false, // WordWrap
    1.0, // Opacity
    [], // [TFillTextFlag.RightToLeft],
    TTextAlign.Leading,
    TTextAlign.Leading);
end;

function TRggLabel.GetListCaption: string;
begin
  result := inherited;
  result := '-- ' + result;
end;

{ TRggPolyLine }

constructor TRggPolyLine.Create(ACaption: string = '');
begin
  inherited;
  TypeName := 'PolyLine';
  PD := TPathData.Create;
end;

constructor TRggPolyLine.Create(ACaption: string; ACount: Integer);
begin
  Create(ACaption);
  if (ACount > 2) and (ACount < 202) then
  begin
    FCount := ACount;
    SetLength(Poly, Count);
    SetLength(TransformedPoly, Count);
  end;
end;

destructor TRggPolyLine.Destroy;
begin
  PD.Free;
  inherited;
end;

procedure TRggPolyLine.Draw(g: TCanvas);
var
  i: Integer;
begin
  Temp1 := Point1.Center + Drawing.FaxPoint3D;
  Temp2 := Point2.Center + Drawing.FaxPoint3D;

  if not ShowPoly then
    inherited
  else
  begin
    g.Stroke.Thickness := StrokeThickness;
    g.Stroke.Color := StrokeColor;
    if Drawing.WantOffset then
    begin
      for i := 0 to Length(Poly) - 1 do
      begin
        TransformedPoly[i].X := Poly[i].X + Drawing.FaxPoint3D.X;
        TransformedPoly[i].Y := Poly[i].Y + Drawing.FaxPoint3D.Y;
      end;
      DrawPoly(g, TransformedPoly);
    end
    else
    DrawPoly(g, Poly);

    DrawText(g);
  end;
end;

procedure TRggPolyLine.DrawText(g: TCanvas);
begin
  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := Drawing.Colors.TextColor;
    TextCenter := Point1.Center.P + (Point2.Center.P - Point1.Center.P) * 0.5;
    TextOut(g, Caption);
  end;
end;

procedure TRggPolyLine.DrawPoly(g: TCanvas; p: TPolygon);
var
  i: Integer;
begin
  if Length(p) = 0 then
    Exit;

  PD.Clear;
  PD.MoveTo(p[0]);
  for i := 1 to Length(p) - 1 do
    PD.LineTo(p[i]);
  g.DrawPath(PD, Opacity);
end;

{ TRggPolyLine }

constructor TRggPolyLine3D.Create(ACaption: string; ACount: Integer);
begin
  inherited;
  TypeName := 'PolyLine3D';
  UpdateCount;
end;

procedure TRggPolyLine3D.UpdateCount;
var
  l: Integer;
begin
  l := Length(Poly);
  if Length(RggPoly) <> l then
    SetLength(RggPoly, l);
  if Length(TransformedPoly) <> l then
    SetLength(TransformedPoly, l);
end;

procedure TRggPolyLine3D.Draw(g: TCanvas);
var
  i: Integer;
begin
  if not Visible then
    Exit;

  if not WantRotation then
  begin
    inherited;
    Exit;
  end;

  if not ShowPoly then
    inherited
  else
  begin
    g.Stroke.Thickness := StrokeThickness;
    g.Stroke.Color := StrokeColor;
    for i := 0 to Length(RggPoly) - 1 do
    begin
      TransformedPoly[i].X := RggPoly[i].X + Drawing.FaxPoint3D.X;
      TransformedPoly[i].Y := RggPoly[i].Y + Drawing.FaxPoint3D.Y;
    end;
    DrawPoly(g, TransformedPoly);
    DrawText(g);
  end;
end;

procedure TRggPolyLine3D.Transform;
var
  i: Integer;
begin
  if not WantRotation then
    Exit;

  Assert(FCount = Length(RggPoly));

  for i := 0 to FCount - 1 do
  begin
    RggPoly[i].C := RggPoly[i].C * TRggCircle.Matrix;
  end;
end;

procedure TRggPolyLine3D.Reset;
var
  i: Integer;
  l: Integer;
begin
  l := Length(RggPoly);
  for i := 0 to l - 1 do
  begin
    RggPoly[i].P := Poly[i];
    RggPoly[i].Z := 0;
  end;
end;

{ TSchnittKKCircleLL }

constructor TSchnittKKCircleLL.Create(ACaption: string);
begin
  inherited;
  TypeName := 'SKK Circle LL';
  IsComputed := True;
  Radius1 := 100;
  Radius2 := 100;
  SchnittKK := TSchnittKK.Create;
end;

destructor TSchnittKKCircleLL.Destroy;
begin
  SchnittKK.Free;
  inherited;
end;

procedure TSchnittKKCircleLL.InitRadius;
begin
  Radius1 := L1.LineLength;
  Radius2 := L2.LineLength;
end;

procedure TSchnittKKCircleLL.Param1(Delta: single);
begin
  Radius1 := Radius1 + Delta;
end;

procedure TSchnittKKCircleLL.Param2(Delta: single);
begin
  Radius2 := Radius2 + Delta;
end;

procedure TSchnittKKCircleLL.GetInfo(ML: TStrings);
begin
  inherited;
  if L1 = nil then
    ML.Add(Caption + '.L1 = nil');
  if L2 = nil then
    ML.Add(Caption + '.L2 = nil');
end;

function TSchnittKKCircleLL.GetValid: Boolean;
begin
  result := inherited;
  result := result and (L1 <> nil);
  result := result and (L2 <> nil);
end;

procedure TSchnittKKCircleLL.Compute;
begin
  Inc(Counter);

  SchnittKK.SchnittEbene := seXY;
  SchnittKK.Radius1 := Radius1;
  SchnittKK.Radius2 := Radius2;
  SchnittKK.MittelPunkt1 := L1.Point1.Center.C;
  SchnittKK.MittelPunkt2 := L2.Point1.Center.C;
  Center.C := SchnittKK.SchnittPunkt2;

  L1.Point2.OriginalCenter.C := Center.C;
  L2.Point2.OriginalCenter.C := Center.C;

  L1.Point2.Center.C := Center.C;
  L2.Point2.Center.C := Center.C;
end;

{ TSchnittKKCircle }

constructor TSchnittKKCircle.Create(ACaption: string);
begin
  inherited;
  TypeName := 'SKK Circle';
  IsComputed := True;
  Radius1 := 100;
  Radius2 := 100;
  NeedCalc := True;
  WantS2 := True;
end;

procedure TSchnittKKCircle.InitRadius;
begin
  Radius1 := (Center - MP1.Center).Length;
  Radius2 := (Center - MP2.Center).Length;
end;

function TSchnittKKCircle.GetBem: TBemerkungKK;
begin
  if NeedCalc = True then
    ComputeInternal;
  result := Bem;
end;

function TSchnittKKCircle.GetBemerkung: string;
begin
  if NeedCalc = True then
    ComputeInternal;
  case Bem of
    bmKonzentrisch:
      result := 'concentric circles';
    bmZwei:
      result := 'two intersections';
    bmEntfernt:
      result := 'two distant circles';
    bmEinerAussen:
      result := 'touching outside';
    bmEinerK1inK2:
      result := 'touching inside, C1 in C2';
    bmEinerK2inK1:
      result := 'touching inside, C2 in C1';
    bmK1inK2:
      result := 'C1 inside C2';
    bmK2inK1:
      result := 'C2 inside C1';
    bmRadiusFalsch:
      result := 'invalid radius';
  end;
end;

procedure TSchnittKKCircle.GetInfo(ML: TStrings);
begin
  inherited;
  if MP1 = nil then
    ML.Add(Caption + '.MP1 = nil');
  if MP2 = nil then
    ML.Add(Caption + '.MP2 = nil');
end;

function TSchnittKKCircle.GetL1: single;
begin
  if NeedCalc then
    ComputeInternal;
  result := (Center - MP1.Center).Length;
end;

function TSchnittKKCircle.GetL2: single;
begin
  if NeedCalc then
    ComputeInternal;
  result := (Center - MP2.Center).Length;
end;

function TSchnittKKCircle.GetValid: Boolean;
begin
  result := inherited;
  result := result and (MP1 <> nil);
  result := result and (MP2 <> nil);
end;

procedure TSchnittKKCircle.Param1(Delta: single);
begin
  Radius1 := Radius1 + Delta;
  NeedCalc := True;
end;

procedure TSchnittKKCircle.Param2(Delta: single);
begin
  Radius2 := Radius2 + Delta;
  NeedCalc := True;
end;

function TSchnittKKCircle.Vorhanden: Boolean;
begin
  if NeedCalc = True then
    ComputeInternal;
  result := sv;
end;

procedure TSchnittKKCircle.ComputeInternal;
var
  a, b, h1, h2, p, q, Entfernung: single;
  DeltaX, DeltaY: single;
  AbsDeltaX, AbsDeltaY: single;
  DeltaNullx, DeltaNully: Boolean;
  M1M2, M1S1, KreuzProd: TPoint3D;
  M1, M2, SP: TPoint3D;
begin
  R1 := Radius1;
  R2 := Radius2;
  M1 := MP1.Center.C;
  M2 := MP2.Center.C;

  NeedCalc := False;
  sv := False;

  S1 := TPoint3D.Zero;
  S2 := TPoint3D.Zero;

  if (R1 <= 0) or (R2 <= 0) then
  begin
    Bem := bmRadiusFalsch;
    Exit;
  end;

  DeltaX := M2.X - M1.X;
  DeltaY := M2.Y - M1.Y;
  DeltaNullx := DeltaX = 0;
  DeltaNully := DeltaY = 0;
  AbsDeltaX := abs(DeltaX);
  AbsDeltaY := abs(DeltaY);

  { Spezialfall konzentrische Kreise }
  if DeltaNullx and DeltaNully then
  begin
    Bem := bmKonzentrisch;
    Exit;
  end;

  h1 := (R1 * R1 - R2 * R2) + (M2.X * M2.X - M1.X * M1.X) + (M2.Y * M2.Y - M1.Y * M1.Y);

  { Rechnung im Normalfall }

  if AbsDeltaY > AbsDeltaX then
  begin
    a := - DeltaX / DeltaY;
    b := h1 / (2 * DeltaY);
    p := 2 * (a * b - M1.X - a * M1.Y) / (1 + a * a);
    q := (M1.X * M1.X + b * b - 2 * b * M1.Y + M1.Y * M1.Y - R1 * R1) / (1 + a * a);
    h2 := p * p / 4 - q;
    if h2 >= 0 then
    begin
      h2 := sqrt(h2);
      S1.X := -p / 2 + h2;
      S2.X := -p / 2 - h2;
      S1.Y := a * S1.X + b;
      S2.Y := a * S2.X + b;
      sv := True;
    end;
  end
  else
  begin
    a := - DeltaY / DeltaX;
    b := h1 / (2 * DeltaX);
    p := 2 * (a * b - M1.Y - a * M1.X) / (1 + a * a);
    q := (M1.Y * M1.Y + b * b - 2 * b * M1.X + M1.X * M1.X - R1 * R1) / (1 + a * a);
    h2 := p * p / 4 - q;
    if h2 >= 0 then
    begin
      h2 := sqrt(h2);
      S1.Y := -p / 2 + h2;
      S2.Y := -p / 2 - h2;
      S1.X := a * S1.Y + b;
      S2.X := a * S2.Y + b;
      sv := True;
    end;
  end;

  Entfernung := (M2 - M1).Length;

  if sv = False then
  begin
    if Entfernung > R1 + R2 then
      Bem := bmEntfernt
    else if Entfernung + R1 < R2 then
      Bem := bmK1inK2
    else if Entfernung + R2 < R1 then
      Bem := bmK2inK1;
    Exit;
  end;

  if sv = True then
  begin
    Bem := bmZwei;
    if Entfernung + R1 = R2 then
      Bem := bmEinerK1inK2
    else if Entfernung + R2 = R1 then
      Bem := bmEinerK2inK1
    else if Entfernung = R1 + R2 then
      Bem := bmEinerAussen;
  end;

  { den "richtigen" SchnittPunkt ermitteln }
  if Bem = bmZwei then
  begin
    M1M2 := M2 - M1;
    M1S1 := S1 - M1;
    KreuzProd := M1M2.CrossProduct(M1S1);
    if KreuzProd.Z < 0 then
    begin
      SP := S2;
      S2 := S1;
      S1 := SP;
    end;
  end;
end;

procedure TSchnittKKCircle.Compute;
begin
//  if NeedCalc then
    ComputeInternal;
  if WantS2 then
    Center.C := S2
  else
    Center.C := S1;
end;

procedure TSchnittKKCircle.Draw(g: TCanvas);
begin
  Temp1 := MP1.Center + Drawing.FaxPoint3D;
  Temp2 := MP2.Center + Drawing.FaxPoint3D;
  Temp3 := Center + Drawing.FaxPoint3D;

  g.Stroke.Thickness := StrokeThickness;
  g.Stroke.Color := StrokeColor;
  g.DrawLine(Temp1.P, Temp3.P, Opacity);
  g.DrawLine(Temp2.P, Temp3.P, Opacity);

  inherited;
end;

{ TRggParam }

constructor TRggParam.Create;
begin
  inherited;
  TypeName := 'Param';
  FScale := 1.0;
  FOriginalValue := 400;
  FValue := FOriginalValue;
  StartPoint := TPointF.Create(10, 10);
  StrokeThickness := 2.0;
  StrokeColor := TRggColors.Gray;
  ShowCaption := True;
end;

procedure TRggParam.Reset;
begin
  FValue := FOriginalValue;
end;

procedure TRggParam.Save;
begin
  FOriginalValue := FValue;
end;

procedure TRggParam.SetBaseValue(const Value: single);
begin
  FBaseValue := Value;
end;

procedure TRggParam.SetScale(const Value: single);
begin
  FScale := Value;
end;

procedure TRggParam.SetValue(const Value: single);
begin
  FValue := Value;
end;

procedure TRggParam.Param1(Delta: single);
begin
  FValue := FValue + Delta;
end;

procedure TRggParam.Draw(g: TCanvas);
var
  EndPoint: TPointF;
begin
  EndPoint.Y := StartPoint.Y;
  EndPoint.X := StartPoint.X + FOriginalValue;

  g.Stroke.Thickness := 5.0;
  g.Stroke.Color := TRggColors.Yellow;
  g.DrawLine(StartPoint, EndPoint, Opacity);

  EndPoint.X := StartPoint.X + FValue;
  g.Stroke.Thickness := 1.0;
  g.Stroke.Color := TRggColors.Navy;
  g.DrawLine(StartPoint, EndPoint, Opacity);

  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := StrokeColor;
    TextCenter := StartPoint;
    TextCenter.Offset(20, -12);
    TextOutLeading(g, Text);
  end;
end;

function TRggParam.GetRelativeValue: single;
begin
  result := FBaseValue + (Value - 400) * FScale;
end;

{ TRggRotaLine }

constructor TRggRotaLine.Create(ACaption: string);
begin
  inherited Create(ACaption);
  TypeName := 'RotaLine';
end;

procedure TRggRotaLine.Param1(Delta: single);
begin
  { swap Params, do inherited Param 2}
  inherited Param2(Delta);
end;

procedure TRggRotaLine.Param2(Delta: single);
begin
  { swap Params, do inherited Param 1}
  inherited Param1(Delta);
end;

{ TFederLine }

constructor TRggFederLine.Create(ACaption: string);
begin
  inherited Create(ACaption, 8);
  TypeName := 'Feder';
end;

procedure TRggFederLine.Draw(g: TCanvas);
var
  i: Integer;
  l: single;
  a: single;
  b: single;
  vp, vq: TPointF;
  vn, wn: TPointF;
  v, w: TPointF;

  p0, p1: TPointF;
  vx, vy: TPoint3D;
begin
  Temp1 := Point1.Center + Drawing.FaxPoint3D;
  Temp2 := Point2.Center + Drawing.FaxPoint3D;

  vp := Temp1.P;
  vq := Temp2.P;

  v := vq - vp;

  vn := v.Normalize;
  vx := TPoint3D.Create(vn.X, vn.Y, 0);
  vy := RotateDegrees(vx, 90);
  wn := TPointF.Create(vy.X, vy.Y);

  l := v.Length;
  a := l / 3 / 8;
  b := 20.0;

  Poly[0] := vp;

  v := vn * 8 * a;
  p0.X := vp.X + v.X;
  p0.Y := vp.Y + v.Y;
  Poly[1] := p0;

  v := vn * a;
  w := wn *  b;
  for i := 2 to FCount-3 do
  begin
    p0 := p0 + v;
    if i mod 2 = 0 then
      p1 := p0 + w
    else
      p1 := p0 - w;
    Poly[i] := p1;
  end;

  p0 := p0 + v;
  Poly[FCount-2] := p0;

  Poly[FCount-1] := vq;

  g.Stroke.Thickness := StrokeThickness;
  g.Stroke.Color := StrokeColor;
  DrawPoly(g, Poly);
end;

function TRggFederLine.RotateDegrees(ov: TPoint3D; wi: single): TPoint3D;
var
  a: single;
  m: TMatrix3D;
begin
  a := DegToRad(DegNormalize(Abs(wi)));
  if wi >= 0 then
    m := TMatrix3D.CreateRotation(TPoint3D.Create(0,0,1), a)
  else
    m := TMatrix3D.CreateRotation(TPoint3D.Create(0,0,-1), a);
  result := ov * m;
end;

{ TRggBigCircle }

constructor TRggBigCircle.Create(ACaption: string);
begin
  inherited Create;
  TypeName := 'BigCircle';
  Caption := ACaption;
  ShowCaption := DefaultShowCaption;
end;

procedure TRggBigCircle.Draw(g: TCanvas);
begin
  g.Fill.Kind := TBrushKind.None;
  inherited;
end;

procedure TRggBigCircle.Param3(Delta: single);
begin
  FRadius := FRadius + Delta;
end;

{ TRggBigArc }

constructor TRggBigArc.Create(ACaption: string);
begin
  inherited Create;
  TypeName := 'BigArc';
  Caption := ACaption;
  ShowCaption := False;
  FSweepAngle := 30;
end;

procedure TRggBigArc.Draw(g: TCanvas);
var
  Arrow: TRggPoint3D;
  Angle: single;
  StartAngle: single;
  RadiusF: TPointF;
begin
  Temp1 := Point1.Center + Drawing.FaxPoint3D;
  Temp2 := Point2.Center + Drawing.FaxPoint3D;

  Arrow := Temp2 - Temp1;
  Angle := RadToDeg(Arrow.P.Angle(TPointF.Zero));
  RadiusF.X := Arrow.Length;
  RadiusF.Y := RadiusF.X;

  StartAngle := Angle - SweepAngle / 2;
  SweepAngle := SweepAngle;

  g.Stroke.Color := StrokeColor;
  g.Stroke.Thickness := StrokeThickness;
  g.DrawArc(Temp1.P, RadiusF, startAngle, sweepAngle, Opacity);

  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := Drawing.Colors.TextColor;
    TextCenter := Temp1.P + (Temp2.P - Temp1.P) * 0.5;
    TextOut(g, Caption);
  end;
end;

procedure TRggBigArc.GetInfo(ML: TStrings);
begin
  inherited;
  if Point1 = nil then
    ML.Add(Caption + '.Point1 = nil');
  if Point2 = nil then
    ML.Add(Caption + '.Point2 = nil');
end;

function TRggBigArc.GetValid: Boolean;
begin
  result := inherited;
  result := result and (Point1 <> nil);
  result := result and (Point2 <> nil);
end;

procedure TRggBigArc.Param1(Delta: single);
begin
  SweepAngle := FSweepAngle + Delta;
end;

procedure TRggBigArc.SetSweepAngle(const Value: single);
begin
  FSweepAngle := Value;
  if FSweepAngle < 10 then
    FSweepAngle := 10;
end;

{ TRggPolyCurve }

procedure TRggPolyCurve.AssignPoly(const APoly: TPolygon);
var
  l: Integer;
begin
  l := Length(APoly);
  Poly := APoly;
  if l <> Count then
  begin
    FCount := l;
    SetLength(TransformedPoly, l);
  end;
end;

constructor TRggPolyCurve.Create(ACaption: string; ACount: Integer);
begin
  inherited Create;
  TypeName := 'PolyCurve';
  Caption := ACaption;
  IndentItem := True;
  PD := TPathData.Create;
  if (ACount > 2) and (ACount < 361) then
  begin
    FCount := ACount;
    SetLength(Poly, Count);
    SetLength(TransformedPoly, Count);
  end;
end;

destructor TRggPolyCurve.Destroy;
begin
  PD.Free;
  inherited;
end;

procedure TRggPolyCurve.Draw(g: TCanvas);
var
  i: Integer;
begin
  g.Stroke.Thickness := StrokeThickness;
  g.Stroke.Color := StrokeColor;

  if Drawing.WantOffset then
  begin
    for i := 0 to Length(Poly) - 1 do
    begin
      TransformedPoly[i].X := Poly[i].X + Drawing.FaxPoint3D.X;
      TransformedPoly[i].Y := Poly[i].Y + Drawing.FaxPoint3D.Y;
    end;
    DrawPoly(g, TransformedPoly);
  end
  else
  DrawPoly(g, Poly);

  DrawText(g);
end;

procedure TRggPolyCurve.DrawText(g: TCanvas);
begin
  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := Drawing.Colors.TextColor;
    if Drawing.WantOffset then
      TextCenter := TransformedPoly[0]
    else
      TextCenter := Poly[0];
    TextOut(g, Caption);
  end;
end;

procedure TRggPolyCurve.DrawPoly(g: TCanvas; p: TPolygon);
var
  i: Integer;
begin
  if Length(p) = 0 then
    Exit;

  PD.Clear;
  PD.MoveTo(p[0]);
  for i := 1 to Length(p) - 1 do
    PD.LineTo(p[i]);
  g.DrawPath(PD, Opacity);
end;

{ TRggColorScheme }

procedure TRggColorScheme.GoDark;
begin
  TextColor := TRggColors.White;
  BackgroundColor := TRggColors.Color333333;
  LabelColor := TRggColors.Antiquewhite;
end;

procedure TRggColorScheme.GoLight;
begin
  TextColor := TRggColors.Black;
  BackgroundColor := TRggColors.White;
  LabelColor := TRggColors.Plum;
end;

{ TRggFixpointCircle }

constructor TRggFixpointCircle.Create(ACaption: string);
begin
  inherited;
  TypeName := 'Circle';
  ShowCaption := False;
  IsComputed := True;
end;

procedure TRggFixpointCircle.Draw(g: TCanvas);
var
  R: TRectF;
begin
  Temp1 := Center + Drawing.FaxPoint3D;

  R := RectF(
    Temp1.X - FRadius,
    Temp1.Y - FRadius,
    Temp1.X + FRadius,
    Temp1.Y + FRadius);

  g.Fill.Color := TRggColors.Plum;
  g.FillEllipse(R, Opacity);
end;

{ TRggDrawingBase }

procedure TRggDrawingBase.GoDark;
begin

end;

procedure TRggDrawingBase.GoLight;
begin

end;

function TRggDrawingBase.GetDefaultShowCaption: Boolean;
begin
  result := TRggElement.DefaultShowCaption;
end;

procedure TRggDrawingBase.SetDefaultShowCaption(const Value: Boolean);
begin
  TRggElement.DefaultShowCaption := Value;
end;

procedure TRggDrawingBase.SetIsDark(const Value: Boolean);
begin
  if FIsDark <> Value then
  begin
    FIsDark := Value;
    if Value then
    begin
      Colors.GoDark;
      GoDark;
    end
    else
    begin
      Colors.GoLight;
      GoLight;
    end;
  end;
end;

{ TRggChart }

procedure TRggChart.LookForYMinMax;
var
  i: Integer;
  t: single;
begin
  Ymax := Poly[0];
  Ymin := Ymax;
  for i := 0 to LNr do
  begin
    t := Poly[i];
    if t > Ymax then
      Ymax := t;
    if t < Ymin then
      Ymin := t;
  end;
end;

constructor TRggChart.Create(ACount: Integer = 20);
begin
  inherited Create;
  TypeName := 'Chart';
  IndentItem := True;

  PD := TPathData.Create;

  LNr := ACount;
  if ACount > 9 then
    LNr := ACount;

  SetLength(Poly, LNr + 1);

  Box.X := 0;
  Box.Y := 0;
  Box.Width := 800;
  Box.Height := 800;

  PointRadius := 3.0;
  CurveOpacity := 1.0;

  WantCurve := True;
end;

destructor TRggChart.Destroy;
begin
  PD.Free;
  inherited;
end;

procedure TRggChart.Draw(g: TCanvas);
begin
  DrawPoly1(g);
end;

procedure TRggChart.DrawPoly2(g: TCanvas);
var
  LineToPoint: TPointF;
  P: TPointF;
  i: Integer;
  tempX: single;
  tempY: single;

  ox, oy: single;

  procedure LineTo(x2, y2: single);
  begin
    g.DrawLine(LineToPoint, PointF(x2, y2), 1.0);
    LineToPoint := PointF(x2, y2);
  end;

begin
  ox := Box.X + Drawing.FaxPoint3D.X;
  oy := Box.Y + Drawing.FaxPoint3D.Y;

  g.Stroke.Thickness := StrokeThickness;
  g.Stroke.Color := StrokeColor;

  g.Stroke.Join := TStrokeJoin.Round;
  g.Stroke.Cap := TStrokeCap.Round;

  if WantCurve then
  begin
    g.Stroke.Color := StrokeColor;
    tempY := Box.Height - Box.Height * (Poly[0] - Ymin) / (Ymax - Ymin);
    P.X := ox;
    P.Y := oy + tempY;
    LineToPoint := P;
    for i := 1 to LNr do
    begin
      tempX := Box.Width * i / LNr;
      tempY := Box.Height - Box.Height * (Poly[i] - Ymin) / (Ymax - Ymin);
      P.X := ox + tempX;
      P.Y := oy + tempY;
      LineTo(P.X, P.Y);
    end;
  end;

  if WantRectangles then
  begin
    g.Stroke.Thickness := 1.0;
    g.Stroke.Color := claWhite;
    g.Fill.Color := StrokeColor;
    for i := 0 to LNr do
    begin
      tempX := Box.Width * i / LNr;
      tempY := Box.Height - Box.Height * (Poly[i] - Ymin) / (Ymax - Ymin);
      P.X := ox + tempX;
      P.Y := oy + tempY;
      g.FillRect(
        RectF(P.X - PointRadius, P.Y - PointRadius,
              P.X + PointRadius, P.Y + PointRadius), 0, 0, [], 1.0);
    end;
  end;

  if WantChartPunktX then
  begin
    g.Stroke.Color := claRed;
    tempX := Box.Width * ((ChartPunktX) - Xmin) / (XMax - Xmin);
    tempY := Box.Height;
    P.X := ox + tempX;
    P.Y := oy + tempY;
    g.FillRect(
      RectF(P.X - PointRadius, P.Y - PointRadius,
            P.X + PointRadius, P.Y + PointRadius), 0, 0, [], 1.0);

  end;
end;

procedure TRggChart.DrawText(g: TCanvas);
begin
  if ShowCaption or GlobalShowCaption then
  begin
    g.Fill.Color := claBlack;
    TextOutLeading(g, Caption);
  end;
end;

procedure TRggChart.InitDefault;
var
  i: Integer;
begin
  for i := 0 to LNr do
  begin
    Poly[i] := sin(i / LNr * 2 * Pi);
  end;
  LookForYMinMax;
end;

procedure TRggChart.DrawPoly1(g: TCanvas);
var
  P: TPointF;
  i: Integer;
  tempX: single;
  tempY: single;
  ox, oy: single;
begin
  if Length(Poly) = 0 then
    Exit;

  ox := Box.X + Drawing.FaxPoint3D.X;
  oy := Box.Y + Drawing.FaxPoint3D.Y;

  g.Stroke.Thickness := StrokeThickness;
  g.Stroke.Color := StrokeColor;

  g.Stroke.Join := TStrokeJoin.Round;
  g.Stroke.Cap := TStrokeCap.Round;

  { Kurve }
  if WantCurve then
  begin
    PD.Clear;
    tempY := Box.Height - Box.Height * (Poly[0] - Ymin) / (Ymax - Ymin);
    P.X := ox;
    P.Y := oy + tempY;
    PD.MoveTo(P);
    for i := 1 to LNr do
    begin
      tempX := Box.Width * (i / LNr);
      tempY := Box.Height - Box.Height * (Poly[i] - Ymin) / (Ymax - Ymin);
      P.X := ox + tempX;
      P.Y := oy + tempY;
      PD.LineTo(P);
    end;
    g.DrawPath(PD, CurveOpacity);
  end;

  if WantRectangles then
  begin
    g.Stroke.Thickness := 1.0;
    g.Stroke.Color := claWhite;
    g.Fill.Color := StrokeColor;
    for i := 0 to LNr do
    begin
      tempX := Box.Width * i / LNr;
      tempY := Box.Height - Box.Height * (Poly[i] - Ymin) / (Ymax - Ymin);
      P.X := ox + tempX;
      P.Y := oy + tempY;
      g.FillRect(
        RectF(P.X - PointRadius, P.Y - PointRadius,
              P.X + PointRadius, P.Y + PointRadius), 0, 0, [], 1.0);
    end;
  end;

  if WantChartPunktX then
  begin
    g.Stroke.Color := claRed;
    tempX := Box.Width * ((ChartPunktX) - Xmin) / (XMax - Xmin);
    tempY := Box.Height;
    P.X := ox + tempX;
    P.Y := oy + tempY;
    g.FillRect(
      RectF(P.X - PointRadius, P.Y - PointRadius,
            P.X + PointRadius, P.Y + PointRadius), 0, 0, [], 1.0);

  end;
end;

{ TRggDrawing }

procedure TRggDrawing.Add(Value: TRggElement);
var
  cr: TRggCircle;
  cl: TRggLine;
begin
  ElementList.Add(Value);

  if Value is TRggCircle then
  begin
    cr := Value as TRggCircle;
    CircleList.Add(cr);
    cr.SpecialDraw := True;
    cr.Save;
  end;

  if Value is TRggLine then
  begin
    cl := Value as TRggLine;
    cl.SpecialDraw := True;
    LineList.Add(cl);
  end;
end;

function TRggDrawing.Find(ACaption: string): TRggCircle;
var
  c: TRggCircle;
begin
  result := nil;
  for c in CircleList do
    if c.Caption = aCaption then
        result := c;
end;

procedure TRggDrawing.Compute;
begin

end;

constructor TRggDrawing.Create;
begin
  Colors.GoLight;
  FName := 'Empty Drawing';
  DefaultShowCaption := True;
  ElementList := TRggElementList.Create;
  CircleList := TRggCircleList.Create;
  LineList := TRggLineList.Create;
  CircleComparer := TRggCircleComparer.Create;
  LineComparer := TRggLineComparer.Create;
  SortedCircleList := TRggCircleList.Create;
  SortedLineList := TRggLineList.Create;
  ML := TStringList.Create;
  WantOffset := True;
  WantSort := True;
end;

procedure TRggDrawing.InitButtons(BG: TRggButtonGroup);
begin
  if BG = nil then
    Exit;
  BG.Reset;
end;

procedure TRggDrawing.InitDefaultPos;
begin

end;

destructor TRggDrawing.Destroy;
var
  i: Integer;
begin
  for i := ElementList.Count-1 downto 0 do
  begin
    ElementList[i].Free;
  end;
  ElementList.Clear;
  ElementList.Free;
  CircleList.Free;
  LineList.Free;
  SortedCircleList.Free;
  SortedLineList.Free;
  ML.Free;
  inherited;
end;

procedure TRggDrawing.Draw(g: TCanvas);
begin
  if WantSort then
    SortedDraw(g)
  else
    UnsortedDraw(g);
end;

procedure TRggDrawing.UnsortedDraw(g: TCanvas);
var
  e: TRggElement;
begin
  for e in ElementList do
  begin
    e.Draw(g);
  end;
end;

procedure TRggDrawing.UpdateDrawing;
begin
  TRggButtonGroup.UpdateDrawing;
end;

procedure TRggDrawing.SetWantSort(const Value: Boolean);
begin
  FWantSort := Value;
end;

procedure TRggDrawing.SortedDraw(g: TCanvas);
var
  cr: TRggCircle;
  cl: TRggLine;
  e: TRggElement;
begin
  SortElements;

  for e in ElementList do
  begin
    if e is TRggTriangle then
    begin
      e.Draw(g);
      e.Painted := True;
    end;
  end;

  for cl in SortedLineList do
  begin
    cl.Draw(g);
    cl.Point1.Draw(g);
    cl.Point2.Draw(g);
    cl.Point1.Painted := True;
    cl.Point2.Painted := True;
  end;

  for cr in SortedCircleList do
  begin
    if not cr.Painted then
      cr.Draw(g);
  end;

  for e in ElementList do
  begin
    if e.Painted or e.SpecialDraw then
      Continue;

    e.Draw(g);
  end;
end;

function TRggDrawing.GetDefaultElementIndex: Integer;
begin
  if DefaultElement = nil then
    result := -1
  else
    result := ElementList.IndexOf(DefaultElement);
end;

function TRggDrawing.GetElement(Index: Integer): TRggElement;
begin
  result := ElementList[Index];
end;

function TRggDrawing.GetIsValid: Boolean;
var
  e: TRggElement;
begin
  result := True;
  for e in ElementList do
  begin
    if not e.GetValid then
    begin
      result := False;
      break;
    end;
  end;
end;

procedure TRggDrawing.GetInfo(ML: TStrings);
var
  e: TRggElement;
begin
  for e in ElementList do
    e.GetInfo(ML);
end;

procedure TRggDrawing.InitItems(ML: TStrings);
var
  d: TRggElement;
begin
  ML.Clear;
  for d in ElementList do
  begin
    ML.Add(d.GetListCaption)
  end;
end;

procedure TRggDrawing.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TRggDrawing.SortElements;
var
  i: Integer;
begin
  if WantSort then
  begin
    TRggLine.ResetCounter;

    SortedCircleList.Clear;
    for i := 0 to CircleList.Count-1 do
      SortedCircleList.Add(CircleList[i]);
    SortedCircleList.Sort(CircleComparer);

    SortedLineList.Clear;
    for i := 0 to LineList.Count-1 do
    begin
      if LineList[i].Visible then
        SortedLineList.Add(LineList[i]);
    end;
    SortedLineList.Sort(LineComparer);
  end;
end;

procedure TRggDrawing.SaveAll;
var
  c: TRggCircle;
begin
  for c in CircleList do
    c.Save;
end;

procedure TRggDrawing.Reset;
var
  c: TRggCircle;
begin
  InitDefaultPos;
  Compute;
  SaveAll;
  for c in CircleList do
    c.Reset;
end;

procedure TRggDrawing.Transform(M: TMatrix3D);
var
  c: TRggCircle;
begin
  TRggCircle.Matrix := M;
  for c in CircleList do
    c.Transform;
end;

procedure TRggDrawing.WriteCode(ML: TStrings);
var
  c: TRggCircle;
begin
  for c in CircleList do
  begin
    c.WriteCode(ML);
  end;
end;

{ TRggDrawings }

procedure TRggDrawings.Add(Value: TRggDrawing);
var
  e: TRggElement;
begin
  DrawingList.Add(Value);

  Value.IsDark := UseDarkColorScheme;

  for e in Value.ElementList do
  begin
    e.Drawing := Value;
  end;
end;

constructor TRggDrawings.Create;
begin
  DrawingList := TRggDrawingList.Create;
end;

destructor TRggDrawings.Destroy;
var
  i: Integer;
begin
  for i := DrawingList.Count-1 downto 0 do
  begin
    DrawingList[i].Free;
  end;
  DrawingList.Clear;
  DrawingList.Free;
  inherited;
end;

procedure TRggDrawings.InitItems(ML: TStrings);
var
  d: TRggDrawing;
begin
  ML.Clear;
  for d in DrawingList do
  begin
    ML.Add(d.Name)
  end;
end;

{ TRggLineComparer }

function TRggLineComparer.Compare(const Left, Right: TRggLine): Integer;
begin
  result := TRggLine.Compare(Left, Right);
end;

{ TRggCircleComparer }

function TRggCircleComparer.Compare(const Left, Right: TRggCircle): Integer;
begin
  result := TRggCircle.Compare(Left, Right);
end;

{ TRggDrawingKK }

constructor TRggDrawingKK.Create;
begin
  inherited;
  SKK := TRggSchnittKK.Create;
  SKK.SchnittEbene := TSchnittEbene.seXY;
end;

destructor TRggDrawingKK.Destroy;
begin
  SKK.Free;
  inherited;
end;

{ TRggButtonGroup }

procedure TRggButtonGroup.Reset;
begin
  Btn1.OnClick := nil;
  Btn2.OnClick := nil;
  Btn3.OnClick := nil;
  Btn4.OnClick := nil;
  Btn5.OnClick := nil;
  Btn6.OnClick := nil;
  Btn7.OnClick := nil;
  Btn8.OnClick := nil;
  Btn9.OnClick := nil;
  Btn0.OnClick := nil;

  BtnA.OnClick := nil;
  BtnB.OnClick := nil;
  BtnC.OnClick := nil;
  BtnD.OnClick := nil;
  BtnE.OnClick := nil;
  BtnF.OnClick := nil;

  Btn1.Text := '1';
  Btn2.Text := '2';
  Btn3.Text := '3';
  Btn4.Text := '4';
  Btn5.Text := '5';
  Btn6.Text := '6';
  Btn7.Text := '7';
  Btn8.Text := '8';
  Btn9.Text := '9';
  Btn0.Text := '0';

  BtnA.Text := 'A';
  BtnB.Text := 'B';
  BtnC.Text := 'C';
  BtnD.Text := 'D';
  BtnE.Text := 'E';
  BtnF.Text := 'F';

  Btn1.Hint := 'Btn 1';
  Btn2.Hint := 'Btn 2';
  Btn3.Hint := 'Btn 3';
  Btn4.Hint := 'Btn 4';
  Btn5.Hint := 'Btn 5';
  Btn6.Hint := 'Btn 6';
  Btn7.Hint := 'Btn 7';
  Btn8.Hint := 'Btn 8';
  Btn9.Hint := 'Btn 9';
  Btn0.Hint := 'Btn 0';

  BtnA.Hint := 'Btn A';
  BtnB.Hint := 'Btn B';
  BtnC.Hint := 'Btn C';
  BtnD.Hint := 'Btn D';
  BtnE.Hint := 'Btn E';
  BtnF.Hint := 'Btn F';
end;

class procedure TRggButtonGroup.UpdateDrawing;
begin
  if Assigned(TRggButtonGroup.OnUpdateDrawing) then
    TRggButtonGroup.OnUpdateDrawing(nil);
end;

{ TOriginalImage }

constructor TOriginalImage.Create(AOwner: TComponent; AWidth: Integer; AHeight: Integer);
begin
  inherited Create(AOwner);
  FNominalSize := TSize.Create(AWidth, AHeight);
  BitmapCollection := TBitmapCollection.Create(FNominalSize);
  SetAcceptsControls(False);
end;

destructor TOriginalImage.Destroy;
begin
  BitmapCollection.Free;
  inherited;
end;

function TOriginalImage.ItemForCurrentScale: TBitmap;
var
  t: single;
begin
  if Scene <> nil then
    t := Scene.GetSceneScale
  else
    t := 1.0;
  if t < 1 then
    t := 1.0;

  if t <> FSS then
  begin
    FSS := t;
    ScreenScaleHasChanged := True
  end;

  result := BitmapCollection.ItemByScale(FSS);
  if result = nil then
    result := BitmapCollection.Add(FSS);
end;

function TOriginalImage.GetBitmap: TBitmap;
begin
  result := ItemForCurrentScale;
end;

procedure TOriginalImage.Paint;
var
  LR: TRectF;
begin
  FCurrentBitmap := GetBitmap;
  if FCurrentBitmap <> nil then
  begin
    R1 := LocalRect;
    R2 := TRectF.Create(R1.Left, R1.Top, R1.Left + FCurrentBitmap.Width, R1.Top + FCurrentBitmap.Height);

    LR := TRectF.Create(R1.Left * FSS, R1.Top * FSS, R1.Right * FSS, R1.Bottom * FSS);
    IntersectRect(IR, LR, R2);

    R1 := TRectF.Create(0, 0, IR.Width, IR.Height);
    R2 := TRectF.Create(R2.Left, R2.Top, R2.Left + IR.Width / FSS, R2.Top + IR.Height / FSS);

    Canvas.DrawBitmap(FCurrentBitmap, R1, R2, 1.0, True);
  end;

  if ScreenScaleHasChanged then
  begin
    ScreenScaleHasChanged := False;
    NotifyScreenScaleChanged;
  end;
end;

procedure TOriginalImage.NotifyScreenScaleChanged;
begin
  if Assigned(FOnScreenScaleChanged) then
    FOnScreenScaleChanged(Self);
end;

procedure TOriginalImage.SetOnScreenScaleChanged(const Value: TNotifyEvent);
begin
  FOnScreenScaleChanged := Value;
end;

{ TBitmapCollection }

constructor TBitmapCollection.Create(ANominalSize: TSize);
begin
  FNominalSize := ANominalSize;
  FBitmaps := TBitmapDict.Create(2);
end;

destructor TBitmapCollection.Destroy;
var
  cr: TBitmap;
begin
  for cr in FBitmaps.Values do
    cr.Free;
  FBitmaps.Free;
  inherited;
end;

function TBitmapCollection.ItemByScale(AScale: single): TBitmap;
begin
  FBitmaps.TryGetValue(AScale, result);
end;

function TBitmapCollection.Add(AScale: single): TBitmap;
var
  w, h: Integer;
begin
  if not FBitmaps.ContainsKey(AScale) then
  begin
    w := Round(FNominalSize.cx * AScale);
    h := Round(FNominalSize.cy * AScale);
    result := TBitmap.Create(w, h);
    FBitmaps.Add(AScale, result);
  end
  else
  begin
    FBitmaps.TryGetValue(AScale, result);
  end;
  Assert(result <> nil);
end;

end.
