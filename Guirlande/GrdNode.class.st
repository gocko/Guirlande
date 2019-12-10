Class {
	#name : #GrdNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children',
		'nextNode',
		'previousNode',
		'name'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdNode >> allNodes [
| children | 

children := OrderedCollection new.
children add: self.
(self isKindOf: GrdChildishNode)
ifTrue: [ self children do: [  :each | children addAll: each allNodes] ].
^ children
]

{ #category : #accessing }
GrdNode >> children [
	^ children
]

{ #category : #testing }
GrdNode >> initialize [
	super initialize.
	children := nil
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
	^ parent
]

{ #category : #accessing }
GrdNode >> parent: aParentNode [

	parent := aParentNode
]

{ #category : #accessing }
GrdNode >> previousNode [
	^ previousNode
]

{ #category : #accessing }
GrdNode >> previousNode: aNode [
	previousNode := aNode
]

{ #category : #accessing }
GrdNode >> rawNode [
	^ rawNode
]

{ #category : #accessing }
GrdNode >> rawNode: aProgramNode [

	rawNode := aProgramNode
]
