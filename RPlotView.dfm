object frmView: TfrmView
  Left = 0
  Top = 0
  ClientHeight = 563
  ClientWidth = 622
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbHorz: TScrollBar
    Left = 0
    Top = 528
    Width = 622
    Height = 16
    Align = alBottom
    PageSize = 0
    TabOrder = 0
    OnChange = FormResize
  end
  object sbVert: TScrollBar
    Left = 606
    Top = 0
    Width = 16
    Height = 528
    Align = alRight
    Kind = sbVertical
    PageSize = 0
    TabOrder = 1
    OnChange = FormResize
  end
  object GraphBox: TScrollBox
    Left = 0
    Top = 0
    Width = 606
    Height = 528
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    TabOrder = 2
    OnMouseWheel = GraphBoxMouseWheel
    object GraphArea: TPaintBox
      Left = 0
      Top = 0
      Width = 602
      Height = 524
      Cursor = crArrow
      Align = alClient
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      OnMouseDown = GraphAreaMouseDown
      OnMouseEnter = GraphAreaMouseEnter
      OnMouseMove = GraphAreaMouseMove
      OnMouseUp = GraphAreaMouseUp
      OnPaint = GraphAreaPaint
      ExplicitWidth = 200
      ExplicitHeight = 200
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 544
    Width = 622
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 150
      end>
  end
end
