Class {
	#name : #GrdConstantNode,
	#superclass : #GrdNode,
	#instVars : [
		'value'
	],
	#category : #Guirlande
}

{ #category : #printing }
GrdConstantNode >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' ' , value printString 
]

{ #category : #accessing }
GrdConstantNode >> value [
	^ value
]

{ #category : #accessing }
GrdConstantNode >> value: anObject [
	value := anObject
]
