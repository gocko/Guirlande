Class {
	#name : #GrdVisualizer,
	#superclass : #Object,
	#category : #Guirlande
}

{ #category : #visualization }
GrdVisualizer >> hasChildBody:n show:view flag:flag visitor: visitor [
	|astv  |
	astv := self visitedTree.
	view nodes: n children forEach: [ : c | 
			 (c isKindOf: GrdDoubleBranchNode) ifTrue:[                               "GrdIfDoubleBranch is different because of: edges connectFrom: #previousNode"
					self showColors:flag node: c view:view visitor:visitor.				
					view shape arrowedLine.	
					view edges connectFromAll: #previousNodes.
					view layout tree 
				] 
			 ifFalse: [ 
				 (c isKindOf: GrdChildishNode) 
					 ifTrue: [ 
						self showColors:flag node: c view:view visitor:visitor.					
						view shape arrowedLine.	
						view edges connectTo: #nextNode.
						view layout tree ] ]
			]
		
	

]

{ #category : #visualization }
GrdVisualizer >> showColors:flag node: c view:view visitor:visitor [	
	(flag ==1) ifTrue:[view shape rectangle fillColor: Color yellow;  withTextAbove.
							self hasChildBody:c show: view flag: 2 visitor: visitor.].
	(flag == 2) ifTrue:[view shape rectangle fillColor: Color green;  withTextAbove.
							self hasChildBody:c show: view flag: 3 visitor: visitor.].	
	(flag == 3) ifTrue: [view shape rectangle fillColor: Color white;  withTextAbove.
							self hasChildBody:c show: view flag: 1 visitor: visitor.].	
]

{ #category : #visualization }
GrdVisualizer >> visitedTree [
	| ast visitor astv|
	ast := RBParser parseMethod: (GrdSample>>#justIfTrueFalseBlokIf) getSourceFromFile .
	visitor := GrdVisitor new.
	astv := (ast acceptVisitor: visitor).
	^ astv.
]

{ #category : #'main methods' }
GrdVisualizer >> visualizeAST [ 
| ast astv visitor c shapes eb lbl lps|
	c := RSCanvas new.
	
	ast := RBParser parseMethod: (GrdSample>>#justIfTrue) getSourceFromFile .
	visitor := RBProgramNodeVisitor new.
	astv := (ast acceptVisitor: visitor).
	astv.
	
	shapes := ast allChildren collect: [ :cls |
		lbl := RSLabel new
			text: cls newSource;
			yourself.
		lps := RSEllipse new
			withBorder.
		RSComposite new
			draggable;
			model: cls;
			shapes: (RSGroup with: lps with: lbl );
			yourself 
		
		 ].
	

	c addAll: shapes.
	
	eb := RSEdgeBuilder line.
	eb canvas: c.
	eb connectFrom: #parent.
	RSTreeLayout on: shapes.
	shapes do: [ :e | e translateBy: 0 @ 0 ].
	c @ RSDraggableCanvas.
	^ c
]

{ #category : #'main methods' }
GrdVisualizer >> visualizeCFG [
	| astv visitor c shapes eb lbl lps nodes|
	c := RSCanvas new.
	
	visitor := GrdVisitor  new.
	astv := ( visitor visitMethodNode: (GrdSample>>#fact) ast).

		
	nodes := astv allNodes.
	
	shapes :=  nodes collect: [ :cls |
			lbl := RSLabel new
			text: cls name;
			yourself.
		lps := RSEllipse new
			withBorder.
		RSComposite new
			draggable;
			model: cls;
			shapes: shapes;"(RSGroup with: lps with: lbl );"
			yourself 
		
		 ].
	

	c addAll: shapes.
	
	eb := RSEdgeBuilder arrowedLine.
	eb canvas: c.
	"eb connectFrom: #parent ".
	eb connectToAll: [:node |  (node children ifNil: [OrderedCollection new]), {node nextNode}  ].

	RSTreeLayout   new 
		
		on: c nodes.
	c @ RSCanvasController.
	^ c	
	

]

{ #category : #'main methods' }
GrdVisualizer >> visualizeCFGAdvanced [
<script: 'self new visualizeCFGAdvanced open'>
	| canvas shapes visitor astv nodes sequence tmp  lbl|

	canvas := RSCanvas new.
	
	visitor := GrdVisitor  new.
	astv := ( visitor visitMethodNode: (GrdSample>>#fact) ast).

		
	nodes := astv allNodes.
	
	shapes := nodes  collect: [ :cls | 
		| kids |
		

		
		(cls isKindOf: GrdChildishNode)
			ifTrue: [ 
				sequence := cls collectThisLevelNodes . 
				kids := sequence collect: [ :met | 
					RSBox new
						model: met;
						size: 50;
						popup;
						color: Color lightBlue  ;
						when: RSMouseClick do: [ :evt | evt shape inspect ];
						yourself.
			 ]]
			ifFalse: [ 
				kids := OrderedCollection new. 
				tmp := RSBox new
						model: cls;
						color: Color lightGreen   ;
						size: 50;
						popup;
						when: RSMouseClick do: [ :evt | evt shape inspect ];
						yourself.
				kids add: tmp ].
			
			RSHorizontalLineLayout on: kids.
			RSComposite new
				model: cls;
				shapes: kids;
				padding: 20;
				color: Color lightGray   ;
				draggable; 
				popup;
				yourself ].
	
	RSEdgeBuilder arrowedLine
		withBorderAttachPoint ;
		canvas: canvas;
		shapes: shapes;
		connectToAll: [:node | (node children ifNil: [OrderedCollection new]), {node nextNode}  ].
	canvas addAll: shapes.
	RSTreeLayout on: shapes.
	canvas @ RSCanvasController.
	^ canvas.  
]
