Class {
	#name : #GrdConditionNode,
	#superclass : #GrdChildishNode,
	#instVars : [
		'condition'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdConditionNode >> condition [
	^ condition
]

{ #category : #accessing }
GrdConditionNode >> condition: aNode [
	condition := aNode
]
