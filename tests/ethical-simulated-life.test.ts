import { describe, it, beforeEach, expect } from "vitest"

describe("Ethical Simulated Life Contract", () => {
  let mockStorage: Map<string, any>
  let nextEntityId: number
  
  beforeEach(() => {
    mockStorage = new Map()
    nextEntityId = 0
  })
  
  const mockContractCall = (method: string, args: any[]) => {
    switch (method) {
      case "register-entity":
        const [type, consciousnessLevel] = args
        nextEntityId++
        mockStorage.set(`entity-${nextEntityId}`, {
          type,
          consciousness_level: consciousnessLevel,
          rights: [],
        })
        return { success: true, value: nextEntityId }
      
      case "grant-right":
        const [entityId, right] = args
        const entity = mockStorage.get(`entity-${entityId}`)
        if (!entity) return { success: false, error: 404 }
        if (entity.rights.length >= 5) return { success: false, error: 401 }
        entity.rights.push(right)
        return { success: true }
      
      case "get-entity":
        return { success: true, value: mockStorage.get(`entity-${args[0]}`) }
      
      default:
        return { success: false, error: "Unknown method" }
    }
  }
  
  it("should register an entity", () => {
    const result = mockContractCall("register-entity", ["AI", 8])
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it("should grant a right to an entity", () => {
    mockContractCall("register-entity", ["AI", 8])
    const result = mockContractCall("grant-right", [1, "free-will"])
    expect(result.success).toBe(true)
  })
  
  it("should get entity information", () => {
    mockContractCall("register-entity", ["AI", 8])
    mockContractCall("grant-right", [1, "free-will"])
    const result = mockContractCall("get-entity", [1])
    expect(result.success).toBe(true)
    expect(result.value).toEqual({
      type: "AI",
      consciousness_level: 8,
      rights: ["free-will"],
    })
  })
})

