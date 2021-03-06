Class {
	#name : #GrdNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children',
		'nextNode',
		'name',
		'previousNodes'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdNode >> addAllNodesTo: kids [


(self unproperNode  or: [kids includes: self ] ) ifFalse: [ kids add: self ].
self nextNode isNil ifFalse:[ self nextNode addAllNodesTo: kids].

^ kids
]

{ #category : #accessing }
GrdNode >> allNodes [
| kids | 

kids := OrderedCollection new.
self addAllNodesTo: kids.

^ kids
]

{ #category : #accessing }
GrdNode >> children [
	^ children
]

{ #category : #testing }
GrdNode >> initialize [
	super initialize.
	name := ''.
	children := nil.
	previousNodes := OrderedCollection new.
	

]

{ #category : #testing }
GrdNode >> isExit [

	^ false
]

{ #category : #testing }
GrdNode >> isReturn [

	^ false
]

{ #category : #accessing }
GrdNode >> name [
	^ name
	
]

{ #category : #accessing }
GrdNode >> name: aName [
	name := aName
	
]

{ #category : #accessing }
GrdNode >> nextNode [
	^nextNode
]

{ #category : #accessing }
GrdNode >> nextNode: aNode [
	nextNode := aNode.
]

{ #category : #accessing }
GrdNode >> parent [
self flag: 'it can have more than one parent. e.g recursive method has more than one parent: initial and recusive call.'.
	^ parent
]

{ #category : #accessing }
GrdNode >> parent: aParentNode [

	parent := aParentNode
]

{ #category : #accessing }
GrdNode >> previousNodes [
	^previousNodes
]

{ #category : #accessing }
GrdNode >> previousNodes: aCollectionOfNodes [
	previousNodes := aCollectionOfNodes
]

{ #category : #accessing }
GrdNode >> unproperNextNode [
	^ self nextNode isNil or: [( self nextNode class = GrdStartNode)  or: [self nextNode class = GrdExitNode ]]
]

{ #category : #accessing }
GrdNode >> unproperNode [
	^ self isNil or: [( self  class = GrdStartNode)  or: [self  class = GrdExitNode ]]
]
