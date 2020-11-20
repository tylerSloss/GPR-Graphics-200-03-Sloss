Constructable in SHADERed lite.
Pipeline:
 Passes:
	scenePlanet:
		Code:
			Fragment: PlanetFS
			Vertex: PlanetVS
		Variables:
			mat4:	uModelMat: 	GeometryTransform
			float: 	Time: 		Time
			mat4:	uViewMat:	View
			mat4:	uProjMat:	Projection
			mat4:	uViewProjMat	ViewProjection
			float:	Thing
			int:	uSun 	= 0
			int:	uErth 	= 1
			int:	uMun 	= 2
			
		Geometry:
			sphere: Sun:
				Radius: 1
				Location: (0, 0, 0)
				Rotation: (90, 0, 0)
				Variable Changed: Thing: 0.0;
			sphere: Erth:
				Radius: 0.2
				Location: (0, 0, 0)
				Rotation: (90, 0, 0)
				Variable Changed: Thing: 1.0;
			sphere: Mun:
				Radius: 0.1
				Location: (0, 0, 0)
				Rotation: (90, 0, 0)
				Variable Changed: Thing: 2.0;
		Out to RT: Planets 

	sceneStars:
		Code:
			Fragment: StarsFS
			Vertex: StarsVS
		Variables:
			mat4:	uModelMat: 	GeometryTransform
			mat4:	uViewMat:	View
			mat4:	uProjMat:	Projection
		Geometry:
			ScreenQuadNDC: Stars
		Out to RT: Space

	displaySpace:
		Code:
			Fragment: ViewFS
			Vertex: ViewVS
		Variables:
			mat4:	uModelMat: 	GeometryTransform
			mat4:	uViewMat:	View
			mat4:	uProjMat:	Projection
			int:	uTexture  = 0
			int:	uTexture2 = 1
		Geometry:
			ScreenQuadNDC: myScreen:

 Objects:
	Texture: Sun_texture.jpg
		bind: scenePlanet (0)
	Texture: 17274108e807373b99c46a573c78580b.jpg
		bind: scenePlanet (1)
	Texture: 2k_mercury
		bind: scenePlanet (2)
	Render Texture: Planets
		bind: displaySpace(0)
		Ratio Size = (1.0, 1.0)
	Render Texture: Space
		bind: displaySpace(1)
		Ratio Size = (1.0, 1.0)