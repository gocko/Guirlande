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
			 (c isKindOf: GrdIfDoubleBranchNode) ifTrue:[                               "GrdIfDoubleBranch is different because of: edges connectFrom: #previousNode"
					self showColors:flag node: c view:view visitor:visitor.				
					view shape arrowedLine.	
					view edges connectFrom: #previousNode.
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
	| ast astv visitor c shapes eb eb2 lbl lps nodes|
	c := RSCanvas new.
	
	ast := RBParser parseMethod: (GrdSample>>##justWhileTrue) getSourceFromFile .
	visitor := GrdVisitor  new.
	astv := (ast acceptVisitor: visitor).
	
	nodes := astv allNodes.
	
	shapes :=  nodes collect: [ :cls |
		lbl := RSLabel new
			text: cls ;
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
	
	eb := RSEdgeBuilder arrowedLine.
	eb canvas: c.
	eb connectFrom: #parent .
	eb connectTo: #nextNode.


	
	RSTreeLayout  on: shapes.
	shapes do: [ :e | e translateBy: 0 @ 0 ].
	c @ RSDraggableCanvas.
	c zoomToFit .
	
	^ c
]
