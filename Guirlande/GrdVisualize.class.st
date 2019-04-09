Class {
	#name : #GrdVisualize,
	#superclass : #Object,
	#category : #Guirlande
}

{ #category : #visualization }
GrdVisualize >> hasChildBody:n show:view flag:flag visitor: visitor [
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
GrdVisualize >> showColors:flag node: c view:view visitor:visitor [	
	(flag ==1) ifTrue:[view shape rectangle fillColor: Color yellow;  withTextAbove.
							self hasChildBody:c show: view flag: 2 visitor: visitor.].
	(flag == 2) ifTrue:[view shape rectangle fillColor: Color green;  withTextAbove.
							self hasChildBody:c show: view flag: 3 visitor: visitor.].	
	(flag == 3) ifTrue: [view shape rectangle fillColor: Color white;  withTextAbove.
							self hasChildBody:c show: view flag: 1 visitor: visitor.].	
]

{ #category : #visualization }
GrdVisualize >> visitedNodes: view [
	|visitor astv|
	visitor := GrdVisitor new.
	astv := self visitedTree. "get body of CFG"
	view nodes: astv children forEach: [ : n | 
			(n isKindOf: GrdChildishNode) ifTrue: [ 
			   view shape rectangle fillColor:Color green; withTextAbove.
			   self hasChildBody:n show: view flag:1 visitor: visitor.
				view shape arrowedLine.	
				view edges connectTo: #nextNode.
				view layout tree. ].
	]. 
]

{ #category : #visualization }
GrdVisualize >> visitedTree [
	| ast visitor astv|
	ast := RBParser parseMethod: (GrdSample>>#justIfTrueFalseBlokIf) getSource.
	visitor := GrdVisitor new.
	astv := (ast acceptVisitor: visitor).
	^ astv.
]

{ #category : #'main methods' }
GrdVisualize >> visualizeAST [	
	| ast visitor view nodesToShow astv|
	ast := RBParser parseMethod: (GrdSample>>#loopExample) getSource.
	visitor := RBProgramNodeVisitor new.
	astv := (ast acceptVisitor: visitor).
	astv.
	view := RTMondrian new.
	view shape ellipse size: 15; color: Color red;  withText.
	nodesToShow := view nodes: ast allChildren.
	view edges
		elements: nodesToShow asIdentityGroup;
		connectFrom: #parent.
	view layout tree.
	
	^ view	
]

{ #category : #'main methods' }
GrdVisualize >> visualizeCFG [
	| view |
	view := RTMondrian new.
	view shape rectangle withTextAbove; fillColor: Color white; borderColor: Color black.
	self visitedTree;
		  visitedNodes: view.
	view shape arrowedLine.					
	view edges connectTo: #nextNode.
	view layout tree.
	^ view 
]
