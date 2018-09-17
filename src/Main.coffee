#target Illustrator
#targetengine main


console =
  log : (str)-> $.writeln str

class SVGcompiler
  # Todo - see about creating a folder
  constructor: () ->
    @sourceDoc = app.activeDocument
    @createDummyDoc()
    @copyGroupedItemsToDummyDoc()
    @dummyDoc.close SaveOptions.DONOTSAVECHANGES

  # Starting to test if we can run the gulp stuff from
  # illustrator.. Maybe someday if I'm feeling adventurous
  # I'll take it further
  runSimpleScript : ()->
    thisFile = new File($.fileName);
    basePath = thisFile.path;
    f        = new File("#{basePath}/test.script");
    console.log f.execute();

  createDummyDoc : () ->
    obj =
      colorMode : DocumentColorSpace.RGB
      height    : 200
      width     : 200

    @dummyDoc = app.documents.add obj.colorMode, obj.width, obj.height

  copyGroupedItemsToDummyDoc : () ->
    docHeight = @dummyDoc.height
    svgsLayer = @sourceDoc.layers.getByName "svgs"
    for item in svgsLayer.groupItems
      newItem      = item.duplicate( @dummyDoc, ElementPlacement.PLACEATEND )
      newItem.left = 0
      newItem.top  = docHeight

      bounds = newItem.controlBounds
      width  = Math.ceil Math.abs(bounds[0] - bounds[2])
      height = Math.ceil Math.abs(bounds[1] - bounds[3])
      newItem.name += "`#{width}x#{height}"
      @exportMiniSvg(item.name, width, height)

      newItem.remove()


  exportMiniSvg : (name, width, height) ->
    dest    = "#{@sourceDoc.path}/compiled/#{name}"
    format  = "SVG"
    options = []

    folder = new Folder "#{@sourceDoc.path}/compiled/"
    if !folder.exists then folder.create()

    exportOptions                    = new ExportOptionsSVG()
    type                             = ExportType.SVG
    fileSpec                         = new File dest
    exportOptions.embedRasterImages  = false
    exportOptions.embedAllFonts      = false
    exportOptions.cssProperties      = SVGCSSPropertyLocation.STYLEELEMENTS
    @dummyDoc.artboards[0].artboardRect = @dummyDoc.pageItems[0].visibleBounds
    @dummyDoc.exportFile fileSpec, type, exportOptions

  exportSvg : () ->
    dest    = "#{@sourceDoc.path}/compiled/#{@sourceDoc.name.split('.')[0]}"
    format  = "SVG"
    options = []

    folder = new Folder "#{@sourceDoc.path}/compiled/"
    if !folder.exists then folder.create()

    exportOptions                    = new ExportOptionsSVG()
    type                             = ExportType.SVG
    fileSpec                         = new File dest
    exportOptions.embedRasterImages  = false
    exportOptions.embedAllFonts      = false
    exportOptions.cssProperties      = SVGCSSPropertyLocation.STYLEELEMENTS

    @dummyDoc.exportFile fileSpec, type, exportOptions
    @dummyDoc.close SaveOptions.DONOTSAVECHANGES


svgCompiler = new SVGcompiler()
# $.writeln folder
