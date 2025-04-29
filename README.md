# Stackbiz.clarity

## Overview
Stackbiz.clarity is a smart contract built on the Clarity language for the Stacks blockchain that manages business registrations within the Stackbiz loyalty ecosystem network. It allows merchants to register their business information, update their profiles, and control their active status in the network.

## Features

- **Merchant Registration**: Businesses can register with their name, profile description, and business category
- **Profile Management**: Registered merchants can update their information or change their activity status
- **Business Category Management**: Administrative functions to add or remove valid business categories
- **Read-only Functions**: Query merchant information and business types

## Contract Constants

- `CONTRACT_ADMIN`: The principal who deployed the contract (has special admin privileges)
- `MAX_BUSINESS_TYPES`: Maximum number of business categories allowed (50)

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Permission denied (admin-only function) |
| u101 | Record not found |
| u102 | Record already exists (duplicate) |
| u103 | Invalid parameters |

## Public Functions

### For Merchants

```clarity
(register-merchant (merchant-name (string-ascii 50)) 
                  (merchant-profile (string-utf8 280)) 
                  (merchant-category (string-ascii 20)))
```
Registers a new merchant in the system. The merchant category must be a pre-defined valid business type.

```clarity
(update-merchant (merchant-name (string-ascii 50)) 
                (merchant-profile (string-utf8 280)) 
                (merchant-category (string-ascii 20)))
```
Updates an existing merchant's profile information.

```clarity
(deactivate-merchant)
```
Sets a merchant's status to inactive.

```clarity
(activate-merchant)
```
Sets a merchant's status to active.

### For Administrators

```clarity
(add-business-type (category-name (string-ascii 20)))
```
Adds a new valid business category to the system. Only callable by the contract administrator.

```clarity
(remove-business-type (category-name (string-ascii 20)))
```
Removes a business category from the system. Only callable by the contract administrator.

## Read-only Functions

```clarity
(get-merchant-info (account principal))
```
Returns the complete merchant profile for a given principal.

```clarity
(is-merchant-active (account principal))
```
Returns a boolean indicating if a merchant is active.

```clarity
(get-business-type-by-id (index uint))
```
Returns the business category name at the specified index.

```clarity
(is-valid-category (category-name (string-ascii 20)))
```
Checks if a category name is valid within the system.

```clarity
(count-business-types)
```
Returns the total number of registered business types.

```clarity
(get-all-business-types)
```
Returns a list of all registered business categories.

## Usage Examples

### Registering as a Merchant

```clarity
;; Register a new coffee shop
(contract-call? .stackbiz register-merchant "Java Junction" "Specialty coffee shop with artisanal beans" "food-and-beverage")
```

### Updating a Merchant Profile

```clarity
;; Update merchant details
(contract-call? .stackbiz update-merchant "Java Junction Cafe" "Award-winning specialty coffee and pastries" "food-and-beverage")
```

### Adding a Business Category (Admin Only)

```clarity
;; Add a new business category
(contract-call? .stackbiz add-business-type "entertainment")
```

## Development and Deployment

1. Deploy the contract to the Stacks blockchain
2. The deployer automatically becomes the CONTRACT_ADMIN
3. The admin should add business categories before merchants can register
4. Merchants can then register by calling the register-merchant function

## Limitations

- Business names are limited to 50 ASCII characters
- Business profiles are limited to 280 UTF-8 characters
- Business categories are limited to 20 ASCII characters
- Maximum of 50 different business categories can be defined

## Security Considerations

- Only the contract administrator can add or remove business categories
- Merchants can only modify their own information
- Validation is performed on all input parameters
